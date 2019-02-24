/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Remove a disappearing parabola from the beachline tree and generate the endpoint for all relevant edges.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_rootPtr", "_p1Event", "_scanlineY", "_edges", "_vertices", "_eventQueue", "_deletedEvents"];
private _p1Ptr = _p1Event#EVENT_ARCH;

//Get parabolas to the left and right of p1
private _leftParentPtr = [_p1Ptr, true] call FUNC(treeGetParent);
private _rightParentPtr = [_p1Ptr, false] call FUNC(treeGetParent);

private _p0Ptr = [_leftParentPtr, true] call FUNC(treeGetLeafChild);
private _p2Ptr = [_rightParentPtr, false] call FUNC(treeGetLeafChild);

#ifdef DO_DEBUG
diag_log text format ["_p1Ptr = %1", _p1Ptr];
diag_log text format ["_p0Ptr = %1", _p0Ptr];
diag_log text format ["_p2Ptr = %1", _p2Ptr];
#endif

if(_p0Ptr == _p2Ptr) then {
    ["REMOVE_PARABOLA - _p0 and _p2 are the same. _this = %1", _this] call BIS_fnc_error;
};

private _p0 = GET_PTR(_p0Ptr);
private _p1 = GET_PTR(_p1Ptr);
private _p2 = GET_PTR(_p2Ptr);

//Check for invalidated events
private _p0Event = _p0#PARABOLA_EVENT;
private _p2Event = _p2#PARABOLA_EVENT;

if(!EVENT_IS_NULL(_p0Event)) then {
    _deletedEvents pushBackUnique _p0event;
    _p0 set [PARABOLA_EVENT, EVENT_NULL];
};

if(!EVENT_IS_NULL(_p2Event)) then {
    _deletedEvents pushBackUnique _p2Event;
    _p2 set [PARABOLA_EVENT, EVENT_NULL];
};

//Find event point
private _eventPoint = _p1Event#EVENT_POINT;
private _pointP = [_eventPoint#POINT_X, [_p1#PARABOLA_SITE, _eventPoint#POINT_X, _scanlineY] call FUNC(getY)];
_vertices pushBack _pointP;

//Set edges end to event point
GET_PTR(GET_PTR(_leftParentPtr)#PARABOLA_EDGE) set [EDGE_END, _pointP];
GET_PTR(GET_PTR(_rightParentPtr)#PARABOLA_EDGE) set [EDGE_END, _pointP];

//Find higher parent
private _higherParentPtr = PTR_NULL;
private _ptr = _p1Ptr;
while { !PTR_IS_NULL(_ptr) } do {
    _ptr = GET_PTR(_ptr)#PARABOLA_PARENT;
    if(_ptr == _leftParentPtr) then { _higherParentPtr = _leftParentPtr; };
    if(_ptr == _rightParentPtr) then { _higherParentPtr = _rightParentPtr; };
};

private _higherParent = GET_PTR(_higherParentPtr);
private _parentEdge = [_pointP, _p0#PARABOLA_SITE, _p2#PARABOLA_SITE] call FUNC(newEdge);
_higherParent set [PARABOLA_EDGE, NEW_PTR(_parentEdge)];
_edges pushBack _parentEdge;

//Get parent and grandparent
private _p1ParentPtr = GET_PTR(_p1Ptr)#PARABOLA_PARENT;
private _p1GrandparentPtr = GET_PTR(_p1ParentPtr)#PARABOLA_PARENT;
private _p1Parent = GET_PTR(_p1ParentPtr);

//Get sibling
private _siblingPtr = _p1Parent#([PARABOLA_LEFT, PARABOLA_RIGHT] select (_p1Parent#PARABOLA_LEFT == _p1Ptr));
if(GET_PTR(_p1GrandparentPtr)#PARABOLA_LEFT == _p1ParentPtr) then {
    [_p1GrandparentPtr, _siblingPtr, true] call FUNC(treeSetChild);
};
if(GET_PTR(_p1GrandparentPtr)#PARABOLA_RIGHT == _p1ParentPtr) then {
    [_p1GrandparentPtr, _siblingPtr, false] call FUNC(treeSetChild);
};

//Delete p1 and its parent edge from the beachline tree (its already stored in edges).
DEL_PTR(_p1ParentPtr);
DEL_PTR(_p1Ptr);

#ifdef DO_DEBUG
[_rootPtr, {_this}] call FUNC(printTree);

diag_log text format ["_p0Ptr = %1", _p0Ptr];
diag_log text format ["_p2Ptr = %1", _p2Ptr];
#endif

//Circle checks
[_p0Ptr, _eventQueue, _vertices, _scanlineY] call FUNC(checkCircle);
[_p2Ptr, _eventQueue, _vertices, _scanlineY] call FUNC(checkCircle);