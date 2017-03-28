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
none
__________________________________________________________________*/
#include "script_component.hpp"
#define VAR_LANDED QUOTE(DOUBLES(ADDON,landAt))
#define VAR_CANCEL QUOTE(DOUBLES(ADDON,cancelLandAt))

params [
	["_heli",objNull,[objNull]],
	["_pos",[0,0,0],[[]]],
	["_type","LAND",[""]],
	["_onComplete",{},[{}]],
	["_params",[],[[]]]
];

_heli setVariable [VAR_LANDED,false];
_heli setVariable [VAR_CANCEL,false];

private _helipad = "Land_HelipadEmpty_F" createVehicle [0,0,0];
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
    {unitReady (driver (_this select 0)) || {!alive (_this select 0)} || {(_this select 0) getVariable [VAR_CANCEL,false]}},
    {
        params ["_heli","_pos","_type","_onComplete","_params","_helipad"];

        if (!alive _heli || {_heli getVariable [VAR_CANCEL,false]}) exitWith {};

        // if object obstructing LZ, command SHOULD redirect heli to empty position
        _heli land _type;
        _heli landAt _helipad;

        // run completion code when heli lands
        [
            {isTouchingGround (_this select 0) || {!alive (_this select 0)} || {(_this select 0) getVariable [VAR_CANCEL,false]}},
            {
                params ["_heli","_onComplete","_params","_helipad"];

                if (!alive _heli || {_heli getVariable [VAR_CANCEL,false]}) exitWith {};

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
                            _heli setVariable [VAR_LANDED,true];
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
