/*
Author:
Nicholas Clark (SENSEI)

Description:
export network traffic, function must be spawned

Arguments:
0: log path <STRING>
1: filters <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define LOG_FILENAME QUOTE(DOUBLES(GVARMAIN(network),log.txt))

params [
    ["_path","",[""]],
    ["_filter",[],[[]]],
    ["_duration",10,[0]]
];

_time = diag_tickTime;
_path = [_path,LOG_FILENAME] joinString "\";
_handle = logNetwork [_path,[]];

waitUntil {diag_tickTime > (_time + _duration)};

logNetworkTerminate _handle;

nil
