/*
Author:
Nicholas Clark (SENSEI)

Description:
export list of class names from CfgVehicles

0 = East
1 = West
2 = Resistance
3 = Civilian

Arguments:
0: side to export <SIDE>
1: type to export <STRING>
2: string used to filter classname <STRING>
3: string used to filter display name <STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_side",0,[0]],
    ["_type","CAManBase",[""]],
    ["_filter","",[""]],
    ["_filterDisplay","",[""]]
];

private _cfg = configFile >> "CfgVehicles";
private _classArr = [];

for "_index" from 0 to (count _cfg - 1) do {
    private _cfgClass = _cfg select _index;

    if (isClass _cfgClass) then {
        private _cfgName = configName _cfgClass;
        private _cfgDisplay = getText (_cfgClass >> "displayName");
        private _cfgSide = getNumber (_cfgClass >> "side");
        private _cfgScope = getNumber (_cfgClass >> "scope");

        if (_cfgSide isEqualTo _side && {_cfgScope > 1} && {_cfgName isKindOf _type} && {(toLower _cfgName find toLower _filter) > -1} && {(toLower _cfgDisplay find toLower _filterDisplay) > -1}) then {
            _classArr pushBack str _cfgName
        };
    };
};

titleText [format ["Exporting %1 classes to clipboard.",count _classArr], "PLAIN"];

_classArr = _classArr joinString ",";

copyToClipboard _classArr;

nil
