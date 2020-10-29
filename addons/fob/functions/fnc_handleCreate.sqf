/*
Author:
Nicholas Clark (SENSEI)

Description:
create FOB on server

Arguments:
0: unit to assign to curator or position <OBJECT,ARRAY>
1: curator points <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_center",objNull,[objNull,[]]],
    ["_points",1,[0]]
];

private _unit = objNull;
private _pos = [];
private _type = "";

switch (typeName _center) do {
    case "OBJECT": {
        _unit = _center;
        _pos = _center modelToWorld [0,3,0];
    };
    case "ARRAY": {
        _pos = _center;
    };
    default {
        _pos = DEFAULT_POS
    };
};

private _composition = [_pos,"mil_cache",_center getDir _pos,false] call EFUNC(main,spawnComposition);
private _anchorObjects = (_composition select 2) select {toLower typeOf _x in FOB_CLASSES};

if !(_anchorObjects isEqualTo []) then {
    GVAR(anchor) = selectRandom _anchorObjects;
} else {
    private _nodes = (_composition select 3) select {(_x select 1) >= 1};

    if (_nodes isEqualTo []) exitWith {};

    GVAR(anchor) = "virtualreammobox_camonet_f" createVehicle DEFAULT_SPAWNPOS;
    GVAR(anchor) setDir (random 360);
    [GVAR(anchor),ATLtoASL ((selectRandom _nodes) select 0)] call EFUNC(main,setPosSafe);
};

if (isNil QGVAR(anchor)) exitWith {
    ERROR_1("%1 does not have a suitable anchor",_composition select 0);
};

publicVariable QGVAR(anchor);
GVAR(anchor) allowDamage false;
clearWeaponCargoGlobal GVAR(anchor);
clearMagazineCargoGlobal GVAR(anchor);
clearItemCargoGlobal GVAR(anchor);
clearBackpackCargoGlobal GVAR(anchor);

// save composition to anchor
GVAR(anchor) setVariable [QGVAR(composition),_composition select 2];

// setup anchor and location on all machines
[[],{
    if (hasInterface) then {
        if (CHECK_ADDON_1(ace_cargo)) then {
            [GVAR(anchor),false] call ace_cargo_fnc_makeLoadable;
        };

         [GVAR(anchor)] call EFUNC(main,armory);
    };

    GVAR(location) = createLocation ["NameCity",getPos GVAR(anchor),GVAR(range),GVAR(range)];
    GVAR(location) setText "Forward Operating Base";
}] remoteExecCall [QUOTE(BIS_fnc_call),0,GVAR(anchor)];

// make sure setup occurs at correct position
[
    {!(FOB_POSITION isEqualTo DEFAULT_POS)},
    {
        params ["_unit","_points"];

        GVAR(respawnPos) = [missionNamespace,FOB_POSITION,"Forward Operating Base"] call BIS_fnc_addRespawnPosition;
        GVAR(curator) addCuratorPoints _points;
        GVAR(curator) setCuratorCoef ["Place",GVAR(placeCoef) min 0];
        GVAR(curator) setCuratorCoef ["Delete",GVAR(deleteCoef) max 0];
        GVAR(curator) setCuratorWaypointCost 0;
        GVAR(curator) addCuratorEditingArea [0,FOB_POSITION,GVAR(range)];
        GVAR(curator) addCuratorCameraArea [0,FOB_POSITION,GVAR(range)];
        GVAR(curator) setCuratorCameraAreaCeiling 40;
        [GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

        if !(isNull _unit) then {
            // if unit is already assigned to a curator,save previous curator for later
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
                    [] remoteExecCall [QFUNC(curatorEH),owner (getAssignedCuratorUnit GVAR(curator)),false];
                },
                [_unit]
            ] call CBA_fnc_waitUntilAndExecute;

            [QEGVAR(approval,add),[FOB_POSITION,AP_FOB]] call CBA_fnc_serverEvent;
        };

        [true,FOB_POSITION] call FUNC(setRecon);
    },
    [_unit,_points]
] call CBA_fnc_waitUntilAndExecute;
