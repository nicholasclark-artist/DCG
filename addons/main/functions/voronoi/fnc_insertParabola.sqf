/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Inserts a new site into the beachline tree.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_rootPtr", "_point", "_scanlineY", "_height", "_edges", "_vertices", "_eventQueue", "_deletedEvents"];
    
// Null case: The tree is empty
private _root = GET_PTR(_rootPtr);
if(PARABOLA_IS_NULL(_root)) exitWith {
    //diag_log text "INSERT_PARABOLA: Tree is empty.";
    private _newParabola = _point call FUNC(newParabola);
    SET_PTR(_rootPtr, _newParabola);
};

// Degenerate case: new point has a y similiar the root y.
_root params ["_rootSite", "_rootIsLeaf"];
if(_rootIsLeaf && _rootSite#POINT_Y - _point#POINT_Y < 1 ) exitWith {
#ifdef DO_DEBUG
    diag_log text "INSERT_PARABOLA: New point close to root.";
#endif
    _point params ["_pointX", "_pointY"];
    _rootSite params ["_rootSiteX", "_rootSiteY"];

    _root set [PARABOLA_IS_LEAF, false];

    private _leftParabola = _rootSite call FUNC(newParabola);
    private _rightParabola = _point call FUNC(newParabola);
    private _leftPtr = NEW_PTR(_leftParabola);
    private _rightPtr = NEW_PTR(_rightParabola);

    [_rootPtr, _leftPtr, true] call FUNC(treeSetChild);
    [_rootPtr, _rightPtr, false] call FUNC(treeSetChild);

    private _start = [(_pointX + _rootSiteX)/2, _height];
    _vertices pushBack _start;

    private _newEdge = if(_pointX < _rootSiteX) then {
        [_start, _rootSite, _point] call FUNC(newEdge)
    } else {
        [_start, _point, _rootSite] call FUNC(newEdge)
    };

    _edges pushBack _newEdge;
    _root set [PARABOLA_EDGE, NEW_PTR(_newEdge)];
};

// General case: New site
_point params ["_pointX", "_pointY"];

//Get the parabola the point is over
private _parabolaPtr = [_rootPtr, _scanlineY, _pointX] call FUNC(getParabolaByX);

#ifdef DO_DEBUG
diag_log text format ["X is over parabola = %1", _parabolaPtr];
#endif	

private _parabola = GET_PTR(_parabolaPtr);

//Delete prior circle event that has nows become invalid.
private _circleEvent = _parabola#PARABOLA_EVENT;
if(!EVENT_IS_NULL(_circleEvent)) then {
    _deletedEvents pushBackUnique _circleEvent;
    _parabola set [PARABOLA_EVENT, PTR_NULL];
};

//Get Y coordinate for new edge.
private _site = _parabola#PARABOLA_SITE;
private _start = [_pointX, [_site, _pointX, _scanlineY] call FUNC(getY)];

//diag_log text format ["_start = %1", _start];

_vertices pushBack _start;

//Create half-edges
private _edgeLeft = [_start, _site, _point] call FUNC(newEdge);
private _edgeRight = [_start, _point, _site] call FUNC(newEdge);

//diag_log text format ["_edgeLeft = %1", _edgeLeft];
//diag_log text format ["_edgeRight = %1", _edgeRight];

//Turn parabola into edge
private _edgeLeftPtr = NEW_PTR(_edgeLeft);
private _edgeRightPtr = NEW_PTR(_edgeRight);
_edgeLeft set [EDGE_NEIGHBOUR, _edgeRightPtr];
_edges pushBack _edgeLeft;

_parabola set [PARABOLA_EDGE, _edgeRightPtr];
_parabola set [PARABOLA_IS_LEAF, false];

//Create new parabolas
private _p0 = _site call FUNC(newParabola);
private _p1 = _point call FUNC(newParabola);
private _p2 = _site call FUNC(newParabola);

private _p0Ptr = NEW_PTR(_p0);
private _p1Ptr = NEW_PTR(_p1);
private _p2Ptr = NEW_PTR(_p2);

//diag_log text format ["_p0 = %1", _p0];
//diag_log text format ["_p1 = %1", _p1];
//diag_log text format ["_p2 = %1", _p2];

//Set right child
[_parabolaPtr, _p2Ptr, false] call FUNC(treeSetChild);

//Set left child
private _innerParabola = [] call FUNC(newParabola);
_innerParabola set [PARABOLA_EDGE, _edgeLeftPtr];
private _innerParabolaPtr = NEW_PTR(_innerParabola);
[_parabolaPtr, _innerParabolaPtr, true] call FUNC(treeSetChild);

//Set left child's children
[_innerParabolaPtr, _p0Ptr, true] call FUNC(treeSetChild);
[_innerParabolaPtr, _p1Ptr, false] call FUNC(treeSetChild);

#ifdef DO_DEBUG
[_rootPtr, {_this}] call FUNC(printTree);
#endif

//Do circle checks
[_p0Ptr, _eventQueue, _vertices, _scanlineY] call FUNC(checkCircle);
[_p2Ptr, _eventQueue, _vertices, _scanlineY] call FUNC(checkCircle);