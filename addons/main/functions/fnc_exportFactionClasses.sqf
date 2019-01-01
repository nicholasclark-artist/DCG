/*
Author:
Nicholas Clark (SENSEI)

Description:
export cfgFactionClasses to clipboard

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private ["_cfgClass","_side"];

// _msg is an array, this makes concatenation faster
private _msg = [format["// Use the 'Entry' item to populate %2 unit pools%1%1",endl,toUpper QUOTE(PREFIX)]];
private _cfg = configFile >> "CfgFactionClasses";

for "_index" from 0 to (count _cfg - 1) do {
    _cfgClass = _cfg select _index;

    if (isClass _cfgClass) then {
        _side = switch (getNumber (_cfgClass >> "side")) do {
            case 0: {EAST};
            case 1: {WEST};
            case 2: {INDEPENDENT};
            case 3: {CIVILIAN};
            default {sideUnknown};
        };

        if (_side in [EAST,WEST,INDEPENDENT,CIVILIAN]) then {
            _msg pushBack (format [
                "Entry: %1 %4Display Name: %2 %4Side: %3 %4%4",
                configName _cfgClass,
                getText (_cfgClass >> "displayName"),
                _side,
                endl
            ]);
        };
    };
};

copyToClipboard (_msg joinString "");

titleText ["Exporting faction list to clipboard.", "PLAIN"];

nil