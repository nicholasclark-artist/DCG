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
#define SIDE_LIST [0,1,2,3]

private _msg = format["// Use the 'Entry' item to populate DCG unit pools%1%1",endl];
private _cfg = configFile >> "CfgFactionClasses";

for "_index" from 0 to (count _cfg - 1) do {
    private _cfgClass = _cfg select _index;

    if (isClass _cfgClass) then {
        private _cfgSide = getNumber (_cfgClass >> "side");
        private _cfgIcon = getText (_cfgClass >> "icon");
        private _side = call {
            if (_cfgSide isEqualTo 0) exitWith {
                EAST;
            };
            if (_cfgSide isEqualTo 1) exitWith {
                WEST;
            };
            if (_cfgSide isEqualTo 2) exitWith {
                INDEPENDENT;
            };
            if (_cfgSide isEqualTo 3) exitWith {
                CIVILIAN;
            };

            sideUnknown
        };

        if (_cfgSide in SIDE_LIST) then {
            _msg = _msg + (format [
                "Entry: %1 %4Display Name: %2 %4Side: %3 %4%4",
                configName _cfgClass,
                getText (_cfgClass >> "displayName"),
                _side,
                endl
            ]);
        };
    };
};

copyToClipboard _msg;

titleText ["Exporting faction list to clipboard.", "PLAIN"];

nil