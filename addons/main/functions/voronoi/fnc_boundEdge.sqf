/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Trims edge at the boundary of the given square [0,0] and [width, height].
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params ["_edge", "_width", "_height"];
_edge params ["_start", "_end", "_leftSite", "_rightSite", "_neighbour", "_lineF", "_lineG", "_dirVect"];

private _area = [
    [0,0,0], 
    [_width, 0, 0], 
    [_width,_height, 0], 
    [0, _height, 0]
];

private _startOk = [_start#0, _start#1, 0] inPolygon _area;
private _endOk = [_end#0, _end#1, 0] inPolygon _area;

#ifdef DO_DEBUG
diag_log text format ["_start = %1", _start];
diag_log text format ["_startOk = %1", _startOk];
diag_log text format ["_end = %1", _end];
diag_log text format ["_endOk = %1", _endOk];
#endif
 
switch (true) do {
    case ( !_startOk && !_endOk ) : {
        //Edge is completely outside, mark for deletion
        _edges set [_forEachIndex, nil];
    };
    case (_startOk && !_endOk): {
        private _mx = if(_dirVect#POINT_X > 0) then {
            _width max (_start#POINT_X + 10) 
        } else {
            0 min (_start#POINT_X - 10) 
        };

        private _my = _mx * _lineF + _lineG;
        
        private _end = if(_my < 0 || _my > _height) then {
            _my = if(_dirVect#POINT_Y > 0) then {
                _height max (_start#POINT_Y + 10) 
            } else {
                0 min (_start#POINT_Y - 10) 
            };

            [(_my-_lineG)/_lineF, _my]
        } else {
            [_mx, _my]
        };

        _x set [EDGE_END, _end];
    };
    case (_endOk && !_startOk): {
        private _mx = if(_dirVect#POINT_X > 0) then {
            0 min (_end#POINT_X - 10) 
        } else {
            _width max (_end#POINT_X + 10) 
        };

        private _my = _mx * _lineF + _lineG;
        
        private _start = if(_my < 0 || _my > _height) then {
            _my = if(_dirVect#POINT_Y > 0) then {
                0 min (_end#POINT_Y - 10) 
            } else {
                _height max (_end#POINT_Y + 10) 
            };

            [(_my-_lineG)/_lineF, _my]
        } else {
            [_mx, _my]
        };

        _x set [EDGE_START, _start];
    };
    
    default { 
        //Do nothing
    };
};