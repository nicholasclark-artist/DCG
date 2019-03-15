/*
Author:
Nicholas Clark (SENSEI)

Description:
parse cfgVehicles to get classes of a specific side and faction 

0 = East
1 = West
2 = Resistance
3 = Civilian

Arguments:
0: config side <NUMBER>
1: factions <STRING>
1: displayName filters <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define CONFIGTOPARSE configFile >> "CfgVehicles"

params [
    ["_side",-1,[0]],
    ["_factions","",[""]],
    ["_filters","",[""]]
];

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
    {getNumber (_x >> 'side') isEqualTo %1} && 
    {toUpper getText (_x >> 'faction') in %2} && 
    {getText (_x >> 'vehicleClass') != 'Autonomous'} &&
    {configName _x isKindOf 'CAManBase' || configName _x isKindOf 'Car' || configName _x isKindOf 'Tank' || configName _x isKindOf 'Air'}
",_side,_factions] configClasses (CONFIGTOPARSE);

// apply filter to configs
_factionCfg = _factionCfg select {
    _class = _x;
    _filters findIf {toLower getText(_class >> "displayName") find _x > -1} < 0
};

// get classes
_factionCfg = _factionCfg apply {configName _x};
private _units = _factionCfg select {_x isKindOf "CAManBase"};
private _land = _factionCfg select {_x isKindOf "LandVehicle"};
private _air = _factionCfg select {_x isKindOf "Air"};

// get special classes using display name
private _officers = _units select {toLower getText (CONFIGTOPARSE >> _x >> "displayName") find "officer" > -1};
private _snipers = _units select {toLower getText (CONFIGTOPARSE >> _x >> "displayName") find "sniper" > -1};

// remove special classes from units
_units = _units - _officers; 
_units = _units - _snipers;

if (_units isEqualTo []) then {WARNING_1("empty unit pool: side %1",_side)};
if (_land isEqualTo []) then {WARNING_1("empty land vehicle pool: side %1",_side)};
if (_air isEqualTo []) then {WARNING_1("empty aircraft pool: side %1",_side)};
if (_officers isEqualTo []) then {WARNING_1("empty officer pool: side %1",_side)};
if (_snipers isEqualTo []) then {WARNING_1("empty sniper pool: side %1",_side)};

INFO_1("parse factions %1 complete",_side);

[_units,_land,_air,_officers,_snipers]