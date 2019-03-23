/*
Author:
Nicholas Clark (SENSEI)

Description:
handle cleanup

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define CLEAN_DIST 250

if (GVAR(cleanup) isEqualTo []) exitWith {};

private _cleanupNow = [];
private _cleanupLater = [];

{
    switch (typeName _x) do {
        case "OBJECT": {
            if !(isNull _x) then {
                if (_x getVariable [QGVAR(forceCleanup),false] || {[getPosATL _x,CLEAN_DIST] call EFUNC(main,getNearPlayers) isEqualTo []}) then {
                    _cleanupNow pushBack _x;
                } else {
                    _cleanupLater pushBack _x;
                };
            };
        };
        case "GROUP": {
            if !(isNull _x) then {
                if (_x getVariable [QGVAR(forceCleanup),false] || {[getPosATL leader _x,CLEAN_DIST] call EFUNC(main,getNearPlayers) isEqualTo []}) then {
                    _cleanupNow pushBack _x;
                } else {
                    _cleanupLater pushBack _x;
                };
            };            
        };
        case "LOCATION": {
            if !(isNull _x) then {
                _cleanupNow pushBack _x;
            };            
        };
        case "STRING": {
            if (CHECK_MARKER(_x)) then {
               _cleanupNow pushBack _x; 
            };
        };
        default { 
            WARNING_1("bad type passed to cleanup handler: %1",typeName _x);    
        };
    };
} forEach GVAR(cleanup);

TRACE_4("",count GVAR(cleanup),count _cleanupNow,count _cleanupLater,GVAR(cleanup));

_cleanupNow call CBA_fnc_deleteEntity;

GVAR(cleanup) = _cleanupLater;

nil