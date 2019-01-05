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
#define CONFIGTOPARSE configFile >> "CfgVehicles"

private _side = _this select 0;

_fnc_parse = {
    params ["_side","_factions","_filters"];

    // remove whitespace
    _factions = _factions splitString toString [32,9,13,10] joinString "";

    // convert to array and format elements
    _filters = _filters splitString ",";
    _factions = _factions splitString ",";
    _filters = _filters apply {toLower _x};
    _factions = _factions apply {toUpper _x};

    // parse CfgVehicles for desired configs
    private _factionCfg = format [" 
        (getNumber (_x >> 'scope') > 1) &&  
        {toUpper getText (_x >> 'faction') in %1} && 
        {getText (_x >> 'vehicleClass') != 'Autonomous'} &&
        {configName _x isKindOf 'CAManBase' || {configName _x isKindOf 'Car'} || {configName _x isKindOf 'Tank'} || {configName _x isKindOf 'Air'}}
    ",_factions] configClasses (CONFIGTOPARSE);

    // apply filter to configs
    _factionCfg = _factionCfg select {
        _class = _x;
        _filters findIf {toLower getText(_class >> "displayName") find _x > -1} < 0;
    };

    // get classes
    _factionCfg = _factionCfg apply {configName _x};
    private _units = _factionCfg select {_x isKindOf "CAManBase"};
    
    // get special classes using display name
    private _officers = _units select {toLower getText ((CONFIGTOPARSE) >> _x >> "displayName") find "officer" > -1};
    private _snipers = _units select {toLower getText ((CONFIGTOPARSE) >> _x >> "displayName") find "sniper" > -1};

    // remove special classes from units
    _units = _units - _officers; 
    _units = _units - _snipers;

    // return [unit pool, vehicle pool, aircraft pool, officer pool, sniper pool]
    [_units, _factionCfg select {_x isKindOf "LandVehicle"}, _factionCfg select {_x isKindOf "Air"}, _officers, _snipers]
};

// @todo check if any pool is empty and log warning
call {
    if (_side isEqualTo 0) exitWith {
        _ret = [_side, GVAR(factionsEast), GVAR(filtersEast)] call _fnc_parse;

        GVAR(unitsEast) = _ret select 0;
        GVAR(vehiclesEast) = _ret select 1;
        GVAR(aircraftEast) = _ret select 2;
        GVAR(officersEast) = _ret select 3;
        GVAR(snipersEast) = _ret select 4;
    };

    if (_side isEqualTo 1) exitWith {
        _ret = [_side, GVAR(factionsWest), GVAR(filtersWest)] call _fnc_parse;

        GVAR(unitsWest) = _ret select 0;
        GVAR(vehiclesWest) = _ret select 1;
        GVAR(aircraftWest) = _ret select 2;
        GVAR(officersWest) = _ret select 3;
        GVAR(snipersWest) = _ret select 4;
    };

    if (_side isEqualTo 2) exitWith {
        _ret = [_side, GVAR(factionsInd), GVAR(filtersInd)] call _fnc_parse;

        GVAR(unitsInd) = _ret select 0;
        GVAR(vehiclesInd) = _ret select 1;
        GVAR(aircraftInd) = _ret select 2;
        GVAR(officersInd) = _ret select 3;
        GVAR(snipersInd) = _ret select 4;
    };

    if (_side isEqualTo 3) exitWith {
        _ret = [_side, GVAR(factionsCiv), GVAR(filtersCiv)] call _fnc_parse;

        GVAR(unitsCiv) = _ret select 0;
        GVAR(vehiclesCiv) = _ret select 1;
        GVAR(aircraftCiv) = _ret select 2;
    };
};

nil