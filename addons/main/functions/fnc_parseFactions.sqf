/*
Author:
Nicholas Clark (SENSEI)

Description:
parse faction settings to populate unit pools

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define FAC_POOL_LIST \
    [ \
        [GVAR(factionWest) splitString ",",[GVAR(unitPoolWest),GVAR(vehPoolWest),GVAR(airPoolWest)]], \
        [GVAR(factionEast) splitString ",",[GVAR(unitPoolEast),GVAR(vehPoolEast),GVAR(airPoolEast)]], \
        [GVAR(factionInd) splitString ",",[GVAR(unitPoolInd),GVAR(vehPoolInd),GVAR(airPoolInd)]], \
        [GVAR(factionCiv) splitString ",",[GVAR(unitPoolCiv),GVAR(vehPoolCiv),GVAR(airPoolCiv)]] \
    ]

private _factions = [];

// combine faction arrays
for "_i" from 0 to 3 do {
   _factions append ((FAC_POOL_LIST select _i) select 0);
};

_factions = _factions apply {toUpper _x};

// parse CfgVehicles for desired configs
_cfgVehicles = format [" 
    (getNumber (_x >> 'scope') >= 2) &&  
    {toUpper getText (_x >> 'faction') in %1} && 
    {getText (_x >> 'vehicleClass') == 'Men' || {getText (_x >> 'vehicleClass') == 'Car'} || {getText (_x >> 'vehicleClass') == 'Support'} || {getText (_x >> 'vehicleClass') == 'Armored'} || {getText (_x >> 'vehicleClass') == 'Air'}}
",_factions] configClasses (configFile >> "CfgVehicles");

{   
    _x params ["_faction", "_pools"];
    _pools params ["_unitPool","_vehPool","_airPool"];

    // get configs of correct faction
    _cfg = _cfgVehicles select {getText (_x >> "faction") in _faction};
    
    // covert configs to classnames 
    _cfg = _cfg apply {configName _x};

    // update pools (global var) in local scope using append
    _unitPool append (_cfg select {_x isKindOf "Man"});
    _vehPool append (_cfg select {_x isKindOf "LandVehicle"});
    _airPool append (_cfg select {_x isKindOf "Air"});
} forEach FAC_POOL_LIST;

nil