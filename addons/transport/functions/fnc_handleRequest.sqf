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
#define VAR_HELIPAD_EXFIL QUOTE(DOUBLES(ADDON,exfil))
#define VAR_HELIPAD_INFIL QUOTE(DOUBLES(ADDON,infil))
#define VAR_REQUESTOR QUOTE(DOUBLES(ADDON,requestor))
#define VAR_MARKER_EXFIL QUOTE(DOUBLES(ADDON,exfilMrk))
#define VAR_MARKER_INFIL QUOTE(DOUBLES(ADDON,infilMrk))
#define IDLE_TIME 300
#define COOLDOWN(REQUESTOR) \
	[ \
		{ \
            {GVAR(status) = TR_READY} remoteExecCall [QUOTE(BIS_fnc_call),_this,false]; \
			GVAR(count) = GVAR(count) - 1; \
			publicVariable QGVAR(count); \
		}, \
		(REQUESTOR), \
		GVAR(cooldown) \
	] call CBA_fnc_waitAndExecute

private _requestor = _this select 0;
private _classname = _this select 1;
private _exfil = _this select 2;
private _infil = _this select 3;
private _exfilMrk = _this select 4;
private _infilMrk = _this select 5;
private _pilot = "";

// refer to requestor by client ID so PVs work if requestor dies
_requestor = owner _requestor;

// increase transport count for all players
GVAR(count) = GVAR(count) + 1;
publicVariable QGVAR(count);

// create transport and helipads
_transport = createVehicle [_classname,[_exfil,4000,4000] call EFUNC(main,findPosSafe),[],0,"FLY"];

private _helipadExfil = "Land_HelipadEmpty_F" createVehicle [0,0,0];
private _helipadInfil = "Land_HelipadEmpty_F" createVehicle [0,0,0];

_helipadExfil setPos _exfil;
_helipadInfil setPos _infil;

// set variables in transport namespace
_transport setVariable [QEGVAR(main,forceCleanup),true];
_transport setVariable [QGVAR(status),TR_NOTREADY,false];
_transport setVariable [VAR_HELIPAD_EXFIL,_helipadExfil,false];
_transport setVariable [VAR_HELIPAD_INFIL,_helipadInfil,false];
_transport setVariable [VAR_REQUESTOR,_requestor,false];
_transport setVariable [VAR_MARKER_EXFIL,_exfilMrk,false];
_transport setVariable [VAR_MARKER_INFIL,_infilMrk,false];

// triggers when transport deleted, after adding to cleanup loop
_transport addEventHandler ["Deleted",{
    _transport = _this select 0;

    deleteMarker (_transport getVariable VAR_MARKER_EXFIL);
    deleteMarker (_transport getVariable VAR_MARKER_INFIL);
    deleteVehicle (_transport getVariable VAR_HELIPAD_EXFIL);
    deleteVehicle (_transport getVariable VAR_HELIPAD_INFIL);

    // set status to waiting to exit handlers
    _transport setVariable [QGVAR(status),TR_WAITING,false];

    COOLDOWN(_transport getVariable VAR_REQUESTOR);
}];

_transport addEventHandler ["GetIn",{
    params ["_transport","_pos","_unit"];

    // get copilot position
    _copilot = _transport turretUnit [0];

    // if player is not in copilot, send reminder
	if (isPlayer _unit && {!(_unit isEqualTo _copilot)}) then {
		[STR_GETIN,false] remoteExecCall [QEFUNC(main,displayText),_unit,false];
	};

	if (isPlayer _unit && {_unit isEqualTo _copilot} && {alive (driver _transport)} && {canMove _transport}) then {
        _transport removeEventHandler ["GetIn",_thisEventHandler];

        // move to drop off position
        _transport move (getPos (_transport getVariable VAR_HELIPAD_INFIL));

        [
            {unitReady _this},
            {
                _this land "GET OUT";
                _this landAt (_transport getVariable VAR_HELIPAD_INFIL);

                // if transport touching ground or status is set to ready enroute
                [
                    {isTouchingGround _this || {COMPARE_STR(_this getVariable QGVAR(status),TR_READY)}},
                    {
                        // exit if status is ready
                        if (COMPARE_STR(_this getVariable QGVAR(status),TR_READY)) exitWith {};

                        // transport complete, remove units and wave off
                        [
                            {
                                {
                                    if !(_x isEqualTo (driver _this)) then {moveOut _x};
                                } forEach (crew _this);

                                // will trigger deleted EH
                                _this call EFUNC(main,cleanup);
                                _this move [0,0,100];
                            },
                            _this,
                            10
                        ] call CBA_fnc_waitAndExecute;
                    },
                    _this
                ] call CBA_fnc_waitUntilAndExecute;
            },
            _transport
        ] call CBA_fnc_waitUntilAndExecute;
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
_pilot assignAsDriver _transport;
_pilot moveInDriver _transport;
_pilot disableAI "FSM";
_pilot setBehaviour "CARELESS";
_pilot addEventHandler ["GetOutMan",{
    deleteVehicle (_this select 0)
}];

_transport enableCopilot false;
_transport lockDriver true;

// move to pick up position
_transport move (getPos (_transport getVariable VAR_HELIPAD_EXFIL));

[
    {unitReady _this},
    {
        _this land "GET IN";
        _this landAt (_transport getVariable VAR_HELIPAD_EXFIL);
    },
    _transport
] call CBA_fnc_waitUntilAndExecute;

[STR_ENROUTE,true] remoteExecCall [QEFUNC(main,displayText),_requestor,false];

// handles transport dying enroute
[{
	params ["_args","_idPFH"];
	_args params ["_requestor","_transport","_pilot"];

    if (COMPARE_STR(_transport getVariable QGVAR(status),TR_WAITING)) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

	if (!alive _pilot || {isTouchingGround _transport && (!(canMove _transport) || (fuel _transport isEqualTo 0))}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
        [STR_KILLED,true] remoteExecCall [QEFUNC(main,displayText),_requestor,false];
        _transport call EFUNC(main,cleanup);
	};
}, 1, [_requestor,_transport,_pilot]] call CBA_fnc_addPerFrameHandler;

// handles transport timeout if player not in copilot
[{
	params ["_args","_idPFH"];
	_args params ["_requestor","_transport","_pilot"];

	if (COMPARE_STR(_transport getVariable QGVAR(status),TR_READY) || {COMPARE_STR(_transport getVariable QGVAR(status),TR_WAITING)}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};

	if (isTouchingGround _transport && {alive _pilot} && {canMove _transport}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;

		[
			{
				params ["_requestor","_pilot","_transport"];

				if (isTouchingGround _transport) then {
					{
						if !(_x isEqualTo _pilot) then {moveOut _x};
					} forEach (crew _transport);

                    // will trigger deleted EH
                    _transport call EFUNC(main,cleanup);
                    _transport move [0,0,100];
				};
			},
			[_requestor,_pilot,_transport],
			IDLE_TIME
		] call CBA_fnc_waitAndExecute;
	};
}, 1, [_requestor,_transport,_pilot]] call CBA_fnc_addPerFrameHandler;
