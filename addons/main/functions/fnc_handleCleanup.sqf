/*
Author:
Nicholas Clark (SENSEI)

Description:
handle cleanup

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define CLEAN_DIST 500

GVAR(cleanup) = GVAR(cleanup) select {!isNull _x}; // remove null elements

if !(GVAR(cleanup) isEqualTo []) then {
    for "_i" from (count GVAR(cleanup) - 1) to 0 step -1 do {
        private _entity = GVAR(cleanup) select _i;

        if !(_entity isEqualType objNull) exitWith {
            _entity call CBA_fnc_deleteEntity;
        };

        if (_entity getVariable [QGVAR(forceCleanup),false] || {[getPos _entity,CLEAN_DIST] call EFUNC(main,getNearPlayers) isEqualTo []}) then {
            _entity call CBA_fnc_deleteEntity;
        };
    };
};
