/*
Author:
Nicholas Clark (SENSEI)

Description:
handles transport requests on client

Arguments:
0: transport classname <STRING>
1: exfil position <ARRAY>
2: infil position <ARRAY>
3: exfil marker <STRING>
4: infil marker <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define HINT_GETIN "A player must be in the copilot position to signal take off."
#define IDLE_TIME 300
#define COOLDOWN \
	[ \
		{ \
			GVAR(ready) = 1; \
			GVAR(count) = GVAR(count) - 1; \
            (owner (_this select 0)) publicVariableClient QGVAR(ready); \
			publicVariable QGVAR(count); \
		}, \
		[_unit], \
		GVAR(cooldown) \
	] call CBA_fnc_waitAndExecute

LOG_1("%1.",_this);

private _unit = _this select 0;
private _classname = _this select 1;
private _exfil = _this select 2;
GVAR(infil) = _this select 3;
private _exfilMrk = _this select 4;
private _infilMrk = _this select 5;

private _pilot = "";
private _dir = 0;
GVAR(ready) = 0;
GVAR(count) = GVAR(count) + 1;
(owner _unit) publicVariableClient QGVAR(ready);
publicVariable QGVAR(count);

// find position away from an occupied location
if (CHECK_ADDON_2(occupy)) then {
	{
		_dir = _dir + ([_exfil, ((EGVAR(occupy,occupiedLocations) select _forEachIndex) select 1)] call BIS_fnc_dirTo);
	} forEach EGVAR(occupy,occupiedLocations);
	_dir = (_dir/(count EGVAR(occupy,occupiedLocations))) + 180;
} else {
	_dir = random 360;
};

_spawnPos = [_exfil,5000,6000,objNull,-1,-1,_dir] call EFUNC(main,findPosSafe);
_transport = createVehicle [_classname,_spawnPos,[],0,"FLY"];

_transport addEventHandler ["GetIn",{
    params ["_veh","_pos","_unit","_tPath"];

    _copilot = _veh turretUnit [0];

	if (isPlayer _unit && {!(_unit isEqualTo _copilot)}) then {
		[HINT_GETIN,false] remoteExecCall [QEFUNC(main,displayText),_unit,false];
	};
	if (isPlayer _unit && {_unit isEqualTo _copilot} && {alive (driver _veh)} && {canMove _veh}) then {
		_veh removeEventHandler ["GetIn",_thisEventHandler];
		_wp = group driver _veh addWaypoint [GVAR(infil), 0];
        _wp setWaypointCompletionRadius 100;
        _wp setWaypointSpeed "FULL";
		_wp setWaypointStatements ["true", format ["
			(vehicle this) land ""GET OUT"";

            [
                {isTouchingGround (vehicle (_this select 0)) || {(missionNamespace getVariable ['%1',-1]) isEqualTo 1}},
                {
                    if ((missionNamespace getVariable ['%1',-1]) isEqualTo 1) exitWith {};

                    [
                        {
                            {
                                if (isPlayer _x) then {moveOut _x};
                            } forEach (crew (vehicle (_this select 0)));

                            missionNameSpace setVariable ['%1', -1];
                            _wp = group (_this select 0) addWaypoint [[0,0,100], 0];
                        },
                        [_this select 0],
                        10
                    ] call CBA_fnc_waitAndExecute;
                },
                [this]
            ] call CBA_fnc_waitUntilAndExecute;
		",QGVAR(ready)]];
	};
}];

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_pilot = "O_Helipilot_F";
	};
	if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
		_pilot = "B_Helipilot_F";
	};
    if (EGVAR(main,playerSide) isEqualTo RESISTANCE) exitWith {
		_pilot = "I_Helipilot_F";
	};
	_pilot = "C_man_w_worker_F";
};

_pilot = createGroup EGVAR(main,playerSide) createUnit [_pilot,[0,0,0], [], 0, "NONE"];
_pilot moveInDriver _transport;
_pilot setBehaviour "CARELESS";
_pilot disableAI "TARGET";
_pilot disableAI "AUTOTARGET";
_pilot disableAI "AUTOCOMBAT";
_pilot disableAI "FSM";

_transport allowCrewInImmobile true;
_transport enableCopilot false;
_transport lockDriver true;
_transport flyInHeight 100;

_wp = group _pilot addWaypoint [_exfil, 0];
_wp setWaypointCompletionRadius 100;
_wp setWaypointStatements ["true", "(vehicle this) land ""GET IN"";"];

[{
	params ["_args","_idPFH"];
	_args params ["_unit","_transport","_pilot","_exfilMrk","_infilMrk"];

	if (GVAR(ready) isEqualTo -1) exitWith { // if transport route complete
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		deleteMarker _exfilMrk;
		deleteMarker _infilMrk;
		_transport call EFUNC(main,cleanup);
		COOLDOWN;
	};
	if (!alive _pilot || {isNull (objectParent _pilot)} || {isTouchingGround _transport && (!(canMove _transport) || (fuel _transport isEqualTo 0))}) exitWith { // if transport destroyed enroute
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		GVAR(ready) = -1;
		deleteMarker _exfilMrk;
		deleteMarker _infilMrk;
		_transport call EFUNC(main,cleanup);
		COOLDOWN;
	};
}, 1, [_unit,_transport,_pilot,_exfilMrk,_infilMrk]] call CBA_fnc_addPerFrameHandler;

// handle transport timeout if player not in copilot
[{
	params ["_args","_idPFH"];
	_args params ["_transport","_pilot"];

	if (GVAR(ready) isEqualTo 1 || {GVAR(ready) isEqualTo -1}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	if (isTouchingGround _transport && {alive _pilot} && {objectParent _pilot isEqualTo _transport} && {canMove _transport}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;

		[
			{
				params ["_pilot","_transport","_unit"];

				if (isTouchingGround _transport) then {
					GVAR(ready) = -1;

					{
						if (isPlayer _x) then {moveOut _x};
					} forEach (crew _transport);

					_wp = group _pilot addWaypoint [[0,0,100], 0];
					(vehicle _pilot) call EFUNC(main,cleanup);
					COOLDOWN;
				};
			},
			[_pilot,_transport,_unit],
			IDLE_TIME
		] call CBA_fnc_waitAndExecute;
	};
}, 1, [_transport,_pilot]] call CBA_fnc_addPerFrameHandler;
