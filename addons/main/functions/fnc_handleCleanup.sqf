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
#define CLEAN_DIST 300

GVAR(cleanup) = GVAR(cleanup) select {!isNull _x}; // remove null elements

if !(GVAR(cleanup) isEqualTo []) then {
    // get non object entities
    private _entities = GVAR(cleanup) select {!(_x isEqualType objNull)};
    
    // get objects, check for force cleanup and near players
    private _objects = GVAR(cleanup) select {
        (_x isEqualType objNull) && 
        {
            _x getVariable [QGVAR(forceCleanup),false] || 
            [getPos _x,CLEAN_DIST] call EFUNC(main,getNearPlayers) isEqualTo []
        }
    };

    _entities append _objects;

    _entities call CBA_fnc_deleteEntity;
};

nil