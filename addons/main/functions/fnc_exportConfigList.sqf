/*
Author:
Nicholas Clark (SENSEI)

Description:
export list of class names from config

Arguments:
0: side to export <SIDE>
1: type to export <STRING>
2: string used to filter classname <STRING>
3: string used to filter display name <STRING>

Return:
text
__________________________________________________________________*/
#include "script_component.hpp"
#define CFGEXPORT(CFGARR,CFGNAME) CFGARR pushBack str CFGNAME

params [
    ["_side",sideUnknown,[sideUnknown]],
    ["_type","MAN",[""]],
    ["_filter","",[""]],
    ["_filterDisplay","",[""]]
];

private _cfg = configFile >> "CfgVehicles";
private _classArr = [];

call {
    if (_side isEqualTo EAST) exitWith {
        _side = 0;
    };
    if (_side isEqualTo WEST) exitWith {
        _side = 1;
    };
    if (_side isEqualTo RESISTANCE) exitWith {
        _side = 2;
    };
    if (_side isEqualTo CIVILIAN) exitWith {
        _side = 3;
    };

    sideUnknown
};

for "_index" from 0 to (count _cfg - 1) do {
	private _cfgClass = _cfg select _index;

	if (isClass _cfgClass) then {
		private _cfgName = configName _cfgClass;
		private _cfgDisplay = getText (_cfgClass >> "displayName");
		private _cfgSide = getNumber (_cfgClass >> "side");
		private _cfgScope = getNumber (_cfgClass >> "scope");

        // exclude officers and snipers if display filter is empty
        if (COMPARE_STR(_filterDisplay,"") && {((toLower _cfgDisplay find "officer") > -1 || (toLower _cfgDisplay find "sniper") > -1)}) exitWith {};

		if (_cfgSide isEqualTo _side && {_cfgScope > 1} && {_cfgName isKindOf _type} && {(toLower _cfgName find toLower _filter) > -1} && {(toLower _cfgDisplay find toLower _filterDisplay) > -1}) then {
            CFGEXPORT(_classArr,_cfgName);
		};
	};
};

titleText [format ["Exporting %1 classes",count _classArr], "PLAIN"];
copyToClipboard (_classArr joinString ",");
