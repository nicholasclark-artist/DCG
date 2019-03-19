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
_transport setVariable [QGVAR(status),TR_STATE_NOTREADY,false];
_transport setVariable [QGVAR(exfil),_exfil,false];
_transport setVariable [QGVAR(infil),_infil,false];
_transport setVariable [QGVAR(requestor),_requestor,false];
_transport setVariable [QGVAR(exfilMrk),_exfilMrk,false];
_transport setVariable [QGVAR(infilMrk),_infilMrk,false];
_transport setVariable [QGVAR(stuckPos),[0,0,0],false];
_transport setVariable [QGVAR(signal),0,true]; // cast to all players so signal action is available

// start cooldown when transport is deleted
_transport addEventHandler ["Deleted",{
    _transport = _this select 0;

    deleteMarker (_transport getVariable QGVAR(exfilMrk));
    deleteMarker (_transport getVariable QGVAR(infilMrk));

    TR_COOLDOWN(_transport getVariable QGVAR(requestor));
}];

// send hint to players who get in transport
_transport addEventHandler ["GetIn",{
    if (isPlayer (_this select 2)) then {
        [TR_STR_GETIN,false] remoteExecCall [QEFUNC(main,displayText),_this select 2,false];
    };
}];

createVehicleCrew _transport;
group _transport addVehicle _transport;
_transport setUnloadInCombat [false,false];

// in case 'setUnloadInCombat' fails
{
    _x addEventHandler ["GetOutMan",{deleteVehicle (_this select 0)}];
} forEach crew _transport;

_pilot = driver _transport;
_pilot disableAI "FSM";
_pilot setBehaviour "CARELESS";

// lock vehicle except cargo
_transport lockDriver true;

{
    _transport lockTurret [_x, true];
} forEach (allTurrets [_transport, false]);

// disable caching on transport, can cause waypoint issues
[QEGVAR(cache,disableGroup),group _transport] call CBA_fnc_serverEvent;

// move to pick up position
TR_EXFIL(_transport);
[TR_STR_ENROUTE,true] remoteExecCall [QEFUNC(main,displayText),_requestor,false];

// move to drop off position
TR_INFIL(_transport);

// handles transport dying enroute
[{
    params ["_args","_idPFH"];
    _args params ["_requestor","_transport"];

    if (COMPARE_STR(_transport getVariable QGVAR(status),TR_STATE_WAITING)) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (isTouchingGround _transport && {!alive _transport || !canMove _transport || fuel _transport isEqualTo 0}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [TR_STR_KILLED,true] remoteExecCall [QEFUNC(main,displayText),_requestor,false];
        _transport setVariable [QEGVAR(main,forceCleanup),true];
        [QEGVAR(main,cleanup),_transport] call CBA_fnc_serverEvent;
    };
}, 1, [_requestor,_transport]] call CBA_fnc_addPerFrameHandler;

// handles transport getting stuck in a hover
[{
    params ["_args","_idPFH"];
    _args params ["_transport"];

    if (!alive _transport || {COMPARE_STR(_transport getVariable QGVAR(status),TR_STATE_WAITING)}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    _stuckPos = _transport getVariable [QGVAR(stuckPos),[0,0,0]];

    if (!isTouchingGround _transport && {unitReady _transport} && {CHECK_DIST2D(getPosWorld _transport,_stuckPos,3)}) then {
        _transport setVariable [QUOTE(DOUBLES(MAIN_ADDON,cancelLandAt)),true];

        if !(_transport getVariable [QGVAR(signal),-1] isEqualTo 1) then {
            TR_EXFIL(_transport);
            WARNING_1("Handle hover bug: send transport to exfil: %1",(getPos _transport) select 2);
        } else {
            TR_INFIL(_transport);
            WARNING_1("Handle hover bug: send transport to infil: %1",(getPos _transport) select 2);
        };
    };

    _transport setVariable [QGVAR(stuckPos),getPosWorld _transport];
}, 10, [_transport]] call CBA_fnc_addPerFrameHandler;

nil
