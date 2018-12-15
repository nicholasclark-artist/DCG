/*
Author:
Nicholas Clark (SENSEI)

Description:
parse faction to populate unit pools

0 = East
1 = West
2 = Resistance
3 = Civilian

Arguments:
0: config side <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _side = _this select 0;

_fnc_parse = {
    _factionStr = _this select 0;

    // remove whitespace
    _factionStr = _factionStr splitString toString [32,9,13,10] joinString "";

    // convert to array and format elements
    _factionArr = _factionStr splitString ",";
    _factionArr = _factionArr apply {toUpper _x};

    // parse CfgVehicles for desired configs
    _factionCfg = format [" 
        (getNumber (_x >> 'scope') >= 2) &&  
        {toUpper getText (_x >> 'faction') in %1} && 
        {getText (_x >> 'vehicleClass') == 'Men' || {getText (_x >> 'vehicleClass') == 'Car'} || {getText (_x >> 'vehicleClass') == 'Support'} || {getText (_x >> 'vehicleClass') == 'Armored'} || {getText (_x >> 'vehicleClass') == 'Air'}}
    ",_factionArr] configClasses (configFile >> "CfgVehicles");

    // get classnames
    _factionCfg = _factionCfg apply {configName _x};

    // return [faction list, unit pool, vehicle pool, aircraft pool]
    [_factionStr, _factionCfg select {_x isKindOf "Man"}, _factionCfg select {_x isKindOf "LandVehicle"}, _factionCfg select {_x isKindOf "Air"}]
};

call {
    if (_side isEqualTo 0) exitWith {
        _ret = [GVAR(factionEast)] call _fnc_parse;

        GVAR(factionEast) = _ret select 0;
        GVAR(unitPoolEast) = _ret select 1;
        GVAR(vehPoolEast) = _ret select 2;
        GVAR(airPoolEast) = _ret select 3;

        INFO_1("Parsing %1",QGVAR(factionEast));
    };

    if (_side isEqualTo 1) exitWith {
        _ret = [GVAR(factionWest)] call _fnc_parse;

        GVAR(factionWest) = _ret select 0;
        GVAR(unitPoolWest) = _ret select 1;
        GVAR(vehPoolWest) = _ret select 2;
        GVAR(airPoolWest) = _ret select 3;

        INFO_1("Parsing %1",QGVAR(factionWest));
    };

    if (_side isEqualTo 2) exitWith {
        _ret = [GVAR(factionInd)] call _fnc_parse;

        GVAR(factionInd) = _ret select 0;
        GVAR(unitPoolInd) = _ret select 1;
        GVAR(vehPoolInd) = _ret select 2;
        GVAR(airPoolInd) = _ret select 3;

        INFO_1("Parsing %1",QGVAR(factionInd));
    };

    if (_side isEqualTo 3) exitWith {
        _ret = [GVAR(factionCiv)] call _fnc_parse;

        GVAR(factionCiv) = _ret select 0;
        GVAR(unitPoolCiv) = _ret select 1;
        GVAR(vehPoolCiv) = _ret select 2;
        GVAR(airPoolCiv) = _ret select 3;

        INFO_1("Parsing %1",QGVAR(factionCiv));
    };
};

nil