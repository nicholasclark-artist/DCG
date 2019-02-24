/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author (mrCurry). 
    You are otherwise free to use this code as you wish.

    Description: Check for upcoming circle events for the given parabola.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_bPtr", "_eventQueue", "_vertices", "_lineY"];

#ifdef DO_DEBUG
diag_log text format ["CircleCheck for parabola %1", _bPtr];
#endif
private _bParabola = GET_PTR(_bPtr);
#ifdef DO_DEBUG
diag_log text format ["Parabola %1: %2", _bPtr, _bParabola];
#endif
private _leftParentPtr = [_bPtr, true] call FUNC(treeGetParent);
private _rightParentPtr = [_bPtr, false] call FUNC(treeGetParent);

#ifdef DO_DEBUG
diag_log text format ["_leftParentPtr = %1", _leftParentPtr];
diag_log text format ["_rightParentPtr = %1", _rightParentPtr];
#endif
private _aPtr = [_leftParentPtr, true] call FUNC(treeGetLeafChild);
private _cPtr = [_rightParentPtr, false] call FUNC(treeGetLeafChild);

private _aValid = !PTR_IS_NULL(_aPtr);
private _cValid = !PTR_IS_NULL(_cPtr);

#ifdef DO_DEBUG
diag_log text format ["Checking circle for  = %1", _bPtr];
diag_log text format ["_aPtr = %1,  _cPtr = %2", _aPtr, _cPtr];
#endif

if(_aValid && _cValid) then {
    private _aParabola = GET_PTR(_aPtr);
    private _cParabola = GET_PTR(_cPtr);

    private _aSite = _aParabola#PARABOLA_SITE;
    private _cSite = _cParabola#PARABOLA_SITE;

#ifdef DO_DEBUG
    diag_log text format ["_aSite = %1,  _cSite = %2, Not Equal = %3", _aSite, _cSite, !(_aSite isEqualTo _cSite)];
#endif
    if(!(_aSite isEqualTo _cSite)) then {
        private _leftParentEdgePtr = GET_PTR(_leftParentPtr)#PARABOLA_EDGE;
        private _rightParentEdgePtr = GET_PTR(_rightParentPtr)#PARABOLA_EDGE;
        private _ins = [_leftParentEdgePtr, _rightParentEdgePtr, _vertices] call FUNC(getEdgeIntersection);
        //diag_log text format ["_ins = %1", _ins];
        if(!POINT_IS_NULL(_ins)) then {
            _ins params ["_insX", "_insY"];
            private _dX = (_aSite#POINT_X - _insX);
            private _dY = (_aSite#POINT_Y - _insY);

            private _d = sqrt ( _dX^2 + _dY^2 );

            //diag_log text format ["_insY - _d = %1", _insY - _d];
            //diag_log text format ["_lineY = %1", _lineY];
            if(_insY - _d < _lineY) then {
                
                private _point = [_insX, _insY - _d];
                private _event = [_point, EVENT_TYPE_CIRCLE] call FUNC(newEvent);
                _vertices pushBack _point;
                _bParabola set [PARABOLA_EVENT, _event];
                _event set [EVENT_ARCH, _bPtr];
#ifdef DO_DEBUG
                diag_log text format ["Adding new circle event: %1", _event];
#endif
                [_eventQueue, _point#POINT_Y, _event] call FUNC(heapInsert);
            };
        };
    };
};