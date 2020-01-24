/*
Author:
Nicholas Clark (SENSEI)

Description:
land helicopter at position

Arguments:
0: helicopter <OBJECT>
1: landing position <ARRAY>
2: completion code <CODE>
3: code params <ANY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_heli",objNull,[objNull]],
    ["_pos",DEFAULT_POS,[[]]],
    ["_onComplete",{},[{}]],
    ["_params",[]]
];

if !(local _heli) exitWith { 
    WARNING_2("skip landing %1 is not local",_heli);
};

// get 2d position
_pos =+ _pos;
_pos resize 2;

// _mrk = createMarker [format["%1",random 10000],_pos];
// _mrk setMarkerType "mil_dot";
// _mrk setMarkerColor "ColorBLUE";
// _mrk setMarkerText "LZ";

// set to -1 to cancel landing
_heli setVariable [QGVAR(landAt),0];

private _helipad = createSimpleObject ["Land_HelipadEmpty_F",[_pos select 0,_pos select 1,getTerrainHeightASL _pos],true];

_heli move _pos;

// close doors while enroute
_heli animateDoor ["door_R",0];
_heli animateDoor ["door_L",0];
_heli animateDoor ["CargoRamp_Open",0];
_heli animateDoor ["Door_rear_source",0];
_heli animateDoor ["Door_6_source",0];
_heli animate ["dvere1_posunZ",0];
_heli animate ["dvere2_posunZ",0];

[
    {
        unitReady (driver (_this select 0)) || {!alive (_this select 0)} || {((_this select 0) getVariable [QGVAR(landAt),0]) < 0}
    },
    {
        params ["_heli","_onComplete","_params","_helipad"];

        if (!alive _heli || {(_heli getVariable [QGVAR(landAt),0]) < 0}) exitWith {
            // cancel moving to lz
            if (alive _heli) then {
                _heli move (getPosATL driver _heli);
            };
        };

        // if object obstructing LZ, command SHOULD redirect heli to empty position
        _heli land "LAND";

        // make sure engine keeps running, may trigger several times during landing
        private _engine = _heli addEventHandler ["Engine",{
            params ["_heli","_engineState"];

            if !(_engineState) then {
                // systemChat "ENGINE ON";
                _heli engineOn true;
            };
        }];

        // run completion code when heli lands
        [
            {
                isTouchingGround (_this select 0) || {!alive (_this select 0)} || {((_this select 0) getVariable [QGVAR(landAt),0]) < 0}
            },
            {
                params ["_heli","_onComplete","_params","_helipad","_engine"];

                if (!alive _heli || {(_heli getVariable [QGVAR(landAt),0]) < 0}) exitWith {
                    // cancel landing in progress 
                    if (alive _heli) then {
                        _heli land "NONE";
                    };
                };
                
                // heli touching ground 
                _heli setVariable [QGVAR(landAt),1];

                // hacky way to make sure helicopter doesn't move after touching down
                _heli move (getPosATL driver _heli);
                _heli flyInHeight 0;

                _heli animateDoor ["door_R",1];
                _heli animateDoor ["door_L",1];
                _heli animateDoor ["CargoRamp_Open",1];
                _heli animateDoor ["Door_rear_source",1];
                _heli animateDoor ["Door_6_source",1];
                _heli animate ["dvere1_posunZ",1];
                _heli animate ["dvere2_posunZ",1];

                _params call _onComplete;
                
                // remove checks after helicopter is safely on ground
                [{
                    deleteVehicle (_this select 1);
                    (_this select 0) removeEventHandler ["Engine",_this select 2];
                    (_this select 0) flyInHeight 100;
                },[_heli,_helipad,_engine],2] call CBA_fnc_waitAndExecute;
            },
            [_heli,_onComplete,_params,_helipad,_engine]
        ] call CBA_fnc_waitUntilAndExecute;
    },
    [_heli,_onComplete,_params,_helipad]
] call CBA_fnc_waitUntilAndExecute;

nil
