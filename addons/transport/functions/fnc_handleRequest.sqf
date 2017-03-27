/*
Author:
Nicholas Clark (SENSEI)

Description:
handles transport requests on server

Arguments:
0: transport requestor <OBJECT>
1: transport classname <STRING>
2: exfil position <ARRAY>
3: infil position <ARRAY>
4: exfil marker <STRING>
5: infil marker <STRING>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_requestor",objNull,[objNull]],
    ["_classname","",[""]],
    ["_exfil",[0,0,0],[[]]],
    ["_infil",[0,0,0],[[]]],
    ["_exfilMrk","",[""]],
    ["_infilMrk","",[""]]
];

// refer to requestor by client ID so PVs work if requestor dies
_requestor = owner _requestor;

// increase transport count for all players
GVAR(count) = GVAR(count) + 1;
publicVariable QGVAR(count);

// create transport
_transport = createVehicle [_classname,_exfil getPos [TR_SPAWN_DIST,random 360],[],0,"FLY"];

// set variables in transport namespace
_transport setVariable [QGVAR(status),TR_NOTREADY,false];
_transport setVariable [VAR_HELIPAD_EXFIL,_exfil,false];
_transport setVariable [VAR_HELIPAD_INFIL,_infil,false];
_transport setVariable [VAR_REQUESTOR,_requestor,false];
_transport setVariable [VAR_MARKER_EXFIL,_exfilMrk,false];
_transport setVariable [VAR_MARKER_INFIL,_infilMrk,false];
_transport setVariable [VAR_STUCKPOS,[0,0,0],false];
_transport setVariable [VAR_SIGNAL,0,true]; // cast to all players so signal action is available

// start cooldown when transport is deleted
_transport addEventHandler ["Deleted",{
    _transport = _this select 0;

    deleteMarker (_transport getVariable VAR_MARKER_EXFIL);
    deleteMarker (_transport getVariable VAR_MARKER_INFIL);

    TR_COOLDOWN(_transport getVariable VAR_REQUESTOR);
}];

// send hint to players who get in transport
_transport addEventHandler ["GetIn",{
    if (isPlayer (_this select 2)) then {
        [STR_GETIN,false] remoteExecCall [QEFUNC(main,displayText),_this select 2,false];
    };
}];

private _pilot = "";

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
_pilot disableAI "FSM";
_pilot setBehaviour "CARELESS";
_pilot addEventHandler ["GetOutMan",{deleteVehicle (_this select 0)}];

// lock cockpit
_transport lockTurret [[0],true];
_transport lockDriver true;

// disable caching on transport, can cause waypoint issues
[group _transport] call EFUNC(cache,disableCache);

// move to pick up position
TR_EXFIL(_transport);
[STR_ENROUTE,true] remoteExecCall [QEFUNC(main,displayText),_requestor,false];

// move to drop off position
TR_INFIL(_transport);

// handles transport dying enroute
[{
	params ["_args","_idPFH"];
	_args params ["_requestor","_transport"];

    if (COMPARE_STR(_transport getVariable QGVAR(status),TR_WAITING)) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

	if (isTouchingGround _transport && {!alive _transport || !canMove _transport || fuel _transport isEqualTo 0}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
        [STR_KILLED,true] remoteExecCall [QEFUNC(main,displayText),_requestor,false];
        _transport setVariable [QEGVAR(main,forceCleanup),true];
        _transport call EFUNC(main,cleanup);
	};
}, 1, [_requestor,_transport]] call CBA_fnc_addPerFrameHandler;

// handles transport getting stuck in a hover
[{
	params ["_args","_idPFH"];
	_args params ["_transport"];

    if (!alive _transport || {COMPARE_STR(_transport getVariable QGVAR(status),TR_WAITING)}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    _stuckPos = _transport getVariable [VAR_STUCKPOS,[0,0,0]];

	if (!isTouchingGround _transport && {unitReady _transport} && {CHECK_DIST2D(getPosWorld _transport,_stuckPos,3)}) then {
        _transport setVariable [QUOTE(DOUBLES(MAIN_ADDON,cancelLandAt)),true];

        if !(_transport getVariable [VAR_SIGNAL,-1] isEqualTo 1) then {
            TR_EXFIL(_transport);
            INFO_1("Handle hover bug: send transport to exfil: %1",(getPos _transport) select 2);
        } else {
            TR_INFIL(_transport);
            INFO_1("Handle hover bug: send transport to infil: %1",(getPos _transport) select 2);
        };
	};

    _transport setVariable [VAR_STUCKPOS,getPosWorld _transport];
}, 10, [_transport]] call CBA_fnc_addPerFrameHandler;

nil
