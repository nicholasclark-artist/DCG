/*
Author:
Nicholas Clark (SENSEI)

Description:
get actual number of available cargo positions from classname

Arguments:
0: vehicle classname <STRING>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_class","",[""]]
];

private _baseCfg = configFile >> "CfgVehicles" >> _class;

private _count = count ("
    if (isText(_x >> 'proxyType') && {getText(_x >> 'proxyType') isEqualTo 'CPCargo'}) then {
        true
    };
" configClasses (_baseCfg >> "Turrets")) + getNumber (_baseCfg >> "transportSoldier");

_count