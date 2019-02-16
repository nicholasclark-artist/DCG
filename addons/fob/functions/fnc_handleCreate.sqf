/*
Author:
Nicholas Clark (SENSEI)

Description:
create FOB on server

Arguments:
0: unit to assign to curator or position <OBJECT,ARRAY>
1: curator points <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_center",objNull,[objNull,[]]],
    ["_points",1,[0]]
];

private _unit = objNull;
private _pos = [];
private _type = "";

call {
    if (_center isEqualType objNull) exitWith {
        _unit = _center;
        _pos = _center modelToWorld [0,3,0];
    };
    if (_center isEqualType []) exitWith {
        _unit = objNull;
        _pos = _center;
    };
};

call {
    if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
        _type = "B_cargoNet_01_ammo_F";
    };
    if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
        _type = "O_cargoNet_01_ammo_F"
    };
    if (EGVAR(main,playerSide) isEqualTo INDEPENDENT) exitWith {
        _type = "I_cargoNet_01_ammo_F"
    };
    _type = "B_cargoNet_01_ammo_F";
};

GVAR(anchor) = _type createVehicle DEFAULT_SPAWNPOS;
GVAR(anchor) setPos _pos;
publicVariable QGVAR(anchor);
GVAR(anchor) allowDamage false;
clearWeaponCargoGlobal GVAR(anchor);
clearMagazineCargoGlobal GVAR(anchor);
clearItemCargoGlobal GVAR(anchor);
clearBackpackCargoGlobal GVAR(anchor);

// setup anchor and location on all machines
[[],{
    if (hasInterface) then {
        if (CHECK_ADDON_1(ace_cargo)) then {
            [GVAR(anchor), false] call ace_cargo_fnc_makeLoadable;
        };

         [GVAR(anchor)] call EFUNC(main,armory);
    };

    GVAR(location) = createLocation ["NameCity",getPos GVAR(anchor),GVAR(range),GVAR(range)];
    GVAR(location) setText "Forward Operating Base";
}] remoteExecCall [QUOTE(BIS_fnc_call),0,GVAR(anchor)];

// make sure setup occurs at correct position
[
    {!(FOB_POSITION isEqualTo [0,0,0])},
    {
        params ["_unit","_points"];

        GVAR(respawnPos) = [missionNamespace,FOB_POSITION,"Forward Operating Base"] call BIS_fnc_addRespawnPosition;
        GVAR(curator) addCuratorPoints _points;
        GVAR(curator) setCuratorCoef ["Place", GVAR(placeCoef) min 0];
        GVAR(curator) setCuratorCoef ["Delete", GVAR(deleteCoef) max 0];
        GVAR(curator) setCuratorWaypointCost 0;
        GVAR(curator) addCuratorEditingArea [0,FOB_POSITION,GVAR(range)];
        GVAR(curator) addCuratorCameraArea [0,FOB_POSITION,GVAR(range)];
        GVAR(curator) setCuratorCameraAreaCeiling 40;
        [GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

        if !(isNull _unit) then {
            // if unit is already assigned to a curator, save previous curator for later
            _previousCurator = getAssignedCuratorLogic _unit;

            if !(isNull _previousCurator) then {
                if !(_previousCurator isEqualTo GVAR(curator)) then {
                    GVAR(curatorExternal) = _previousCurator;
                };
            };

            [GVAR(curator),_unit] call FUNC(handleAssign);

            // unit does not immediately become owner of curator
            [
                {getAssignedCuratorUnit GVAR(curator) isEqualTo (_this select 0)},
                {
                    [] remoteExecCall [QFUNC(curatorEH), owner (getAssignedCuratorUnit GVAR(curator)), false];
                },
                [_unit]
            ] call CBA_fnc_waitUntilAndExecute;

            [FOB_POSITION,AP_FOB] call EFUNC(approval,addValue);
        };

        [true,FOB_POSITION] call FUNC(handleRecon);
    },
    [_unit,_points]
] call CBA_fnc_waitUntilAndExecute;
