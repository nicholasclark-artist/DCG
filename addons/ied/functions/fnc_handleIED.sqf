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
    _near = _x nearEntities [["CAManBase","LandVehicle"],4];

    if (_near findIf {isPlayer _x} >= 0) then {
        GVAR(list) deleteAt (GVAR(list) find _x);
        (selectRandom ["R_TBG32V_F","HelicopterExploSmall"]) createVehicle (getPosATL _x);
        deleteVehicle _x;
    };
} forEach GVAR(list);

nil