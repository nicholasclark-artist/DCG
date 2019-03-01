/*
Author:
Nicholas Clark (SENSEI)

Description:
handle vanilla ieds

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (GVAR(list) isEqualTo []) exitWith {
    [_this#1] call CBA_fnc_removePerFrameHandler;
};

{
    _near = _x nearEntities [["CAManBase", "LandVehicle"], 4];
    _near = _near select {isPlayer _x};

    if !(_near isEqualTo []) then {
        GVAR(list) deleteAt (GVAR(list) find _x);
        (selectRandom TYPE_EXP) createVehicle (getPosATL _x);
        deleteVehicle _x;
    };
} forEach GVAR(list);

nil