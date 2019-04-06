/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

["CBA_settingsInitialized", {
    if (!EGVAR(main,enable) || {!GVAR(enable)}) exitWith {LOG(MSG_EXIT)};

    // debug 
    if !([EGVAR(main,locations)] call CBA_fnc_isHash) exitWith {
        ERROR_MSG("hash does not exist!!!");
    };

    [QGVAR(stop), {_this call FUNC(handleStop)}] call CBA_fnc_addEventHandler;

    // headless client exit 
    if (!isServer) exitWith {};

    [QGVAR(question), {_this call FUNC(handleQuestion)}] call CBA_fnc_addEventHandler;
    [QGVAR(hint), {_this call FUNC(handleHint)}] call CBA_fnc_addEventHandler;
    [QGVAR(add), {
        _this call FUNC(addValue);
        TRACE_1("client add value",_this);
    }] call CBA_fnc_addEventHandler;

    call FUNC(init);
    remoteExecCall [QFUNC(initClient),0,true];
}] call CBA_fnc_addEventHandler;