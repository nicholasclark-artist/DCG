/*
Author:
Nicholas Clark (SENSEI)

Description:
land helicopter at position

Arguments:
0: helicopter <OBJECT>
1: landing position <ARRAY>
2: landing type ("LAND","GET IN","GET OUT") <STRING>
3: completion code <CODE>
4: code params <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_heli",objNull,[objNull]],
    ["_pos",[0,0,0],[[]]],
    ["_type","LAND",[""]],
    ["_onComplete",{},[{}]],
    ["_params",[],[[]]]
];

_heli setVariable [QGVAR(landAt),false];
_heli setVariable [QGVAR(cancelLandAt),false];

private _helipad = "Land_HelipadEmpty_F" createVehicle DEFAULT_SPAWNPOS;
_helipad setPos _pos;
_heli doMove _pos;

// close doors while enroute
_heli animateDoor ["door_R", 0];
_heli animateDoor ["door_L", 0];
_heli animateDoor ["CargoRamp_Open", 0];
_heli animateDoor ["Door_rear_source", 0];
_heli animateDoor ["Door_6_source", 0];
_heli animate ["dvere1_posunZ", 0];
_heli animate ["dvere2_posunZ", 0];

[
    {unitReady (driver (_this select 0)) || {!alive (_this select 0)} || {(_this select 0) getVariable [QGVAR(cancelLandAt),false]}},
    {
        params ["_heli","_pos","_type","_onComplete","_params","_helipad"];

        if (!alive _heli || {_heli getVariable [QGVAR(cancelLandAt),false]}) exitWith {};

        // if object obstructing LZ, command SHOULD redirect heli to empty position
        _heli land _type;
        _heli landAt _helipad;

        // run completion code when heli lands
        [
            {isTouchingGround (_this select 0) || {!alive (_this select 0)} || {(_this select 0) getVariable [QGVAR(cancelLandAt),false]}},
            {
                params ["_heli","_onComplete","_params","_helipad"];

                if (!alive _heli || {_heli getVariable [QGVAR(cancelLandAt),false]}) exitWith {};

                _heli animateDoor ["door_R", 1];
                _heli animateDoor ["door_L", 1];
                _heli animateDoor ["CargoRamp_Open", 1];
                _heli animateDoor ["Door_rear_source", 1];
                _heli animateDoor ["Door_6_source", 1];
                _heli animate ["dvere1_posunZ", 1];
                _heli animate ["dvere2_posunZ", 1];

                // check if heli has actually landed, sometimes heli will touch ground and rise to a hover if object is interferring with LZ
                [
                    {
                        params ["_heli","_onComplete","_params","_helipad"];

                        if (isTouchingGround _heli) then {
                            _heli setVariable [QGVAR(landAt),true];
                            _params = [_heli] + _params;
                            _params call _onComplete;
                            deleteVehicle _helipad;
                        };
                    },
                    [_heli,_onComplete,_params,_helipad],
                    1.5
                ] call CBA_fnc_waitAndExecute;
            },
            [_heli,_onComplete,_params,_helipad]
        ] call CBA_fnc_waitUntilAndExecute;
    },
    [_heli,_pos,_type,_onComplete,_params,_helipad]
] call CBA_fnc_waitUntilAndExecute;

nil
