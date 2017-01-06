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
			GVAR(status) = TR_READY; \
			GVAR(count) = GVAR(count) - 1; \
			publicVariable QGVAR(count); \
		}, \
		[], \
		GVAR(cooldown) \
	] call CBA_fnc_waitAndExecute

private _classname = _this select 0;
private _exfil = _this select 1;
GVAR(infil) = _this select 2;
private _exfilMrk = _this select 3;
private _infilMrk = _this select 4;

private _pilot = "";

GVAR(status) = TR_NOTREADY;
GVAR(count) = GVAR(count) + 1;
publicVariable QGVAR(count);

_spawnPos = [_exfil,4000,4000] call EFUNC(main,findPosSafe);
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
		_wp setWaypointStatements ["true", format ["
			(vehicle this) land ""GET OUT"";

            [
                {isTouchingGround (vehicle (_this select 0)) || {(missionNamespace getVariable '%1') == '%2'}},
                {
                    if ((missionNamespace getVariable '%1') == '%2') exitWith {};

                    [
                        {
                            {
                                if (isPlayer _x) then {moveOut _x};
                            } forEach (crew (vehicle (_this select 0)));

                            missionNameSpace setVariable ['%1', '%3'];
                            _wp = group (_this select 0) addWaypoint [[0,0,100], 0];
                        },
                        [_this select 0],
                        10
                    ] call CBA_fnc_waitAndExecute;
                },
                [this]
            ] call CBA_fnc_waitUntilAndExecute;
		",QGVAR(status),TR_READY,TR_WAITING]];
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

_transport allowCrewInImmobile true;
_transport enableCopilot false;
_transport lockDriver true;

_pilot = createGroup EGVAR(main,playerSide) createUnit [_pilot,[0,0,0], [], 0, "NONE"];
_pilot moveInDriver _transport;
_pilot disableAI "FSM";
_pilot setBehaviour "CARELESS";

_wp = group _pilot addWaypoint [_exfil, 0];
_wp setWaypointCompletionRadius 100;
_wp setWaypointStatements ["true", "(vehicle this) land ""GET IN"";"];

[{
	params ["_args","_idPFH"];
	_args params ["_transport","_pilot","_exfilMrk","_infilMrk"];

	if (COMPARE_STR(GVAR(status),TR_WAITING)) exitWith { // if transport route complete
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		deleteMarker _exfilMrk;
		deleteMarker _infilMrk;
		_transport call EFUNC(main,cleanup);
		COOLDOWN;
	};

	if (!alive _pilot || {isTouchingGround _transport && (!(canMove _transport) || (fuel _transport isEqualTo 0))}) exitWith { // if transport destroyed enroute
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		GVAR(status) = TR_WAITING;
		deleteMarker _exfilMrk;
		deleteMarker _infilMrk;
		_transport call EFUNC(main,cleanup);
		COOLDOWN;
	};
}, 1, [_transport,_pilot,_exfilMrk,_infilMrk]] call CBA_fnc_addPerFrameHandler;

// handle transport timeout if player not in copilot
[{
	params ["_args","_idPFH"];
	_args params ["_transport","_pilot"];

	if (COMPARE_STR(GVAR(status),TR_READY) || {COMPARE_STR(GVAR(status),TR_WAITING)}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	if (isTouchingGround _transport && {alive _pilot} && {canMove _transport}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;

		[
			{
				params ["_pilot","_transport"];

				if (isTouchingGround _transport) then {
					GVAR(status) = TR_WAITING;

					{
						if (isPlayer _x) then {moveOut _x};
					} forEach (crew _transport);

					_wp = group _pilot addWaypoint [[0,0,100], 0];
					_transport call EFUNC(main,cleanup);
					COOLDOWN;
				};
			},
			[_pilot,_transport],
			IDLE_TIME
		] call CBA_fnc_waitAndExecute;
	};
}, 1, [_transport,_pilot]] call CBA_fnc_addPerFrameHandler;
