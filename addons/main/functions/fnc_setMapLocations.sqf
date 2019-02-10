/*
Author:
Nicholas Clark (SENSEI)

Description:
set map location data

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SAFE_DIST 2

// get map locations from config
private _cfgLocations = configFile >> "CfgWorlds" >> worldName >> "Names";
private _typeLocations = ["namecitycapital","namecity","namevillage"];
private _typeLocals = ["namelocal"];
private _typeHills = ["hill"];
private _typeMarines = ["namemarine"];

private ["_location","_type","_name","_position","_size"];

for "_i" from 0 to (count _cfgLocations) - 1 do {
    _location = _cfgLocations select _i;
    _type = getText (_location >> "type");
    _name = getText (_location >> "name");
    _position = getArray (_location >> "position");
    _position set [2,(getTerrainHeightASL _position) max 0];
    _size = ((getNumber (_location >> "radiusA")) + (getNumber (_location >> "radiusB")))*0.5;

    call {
        if (toLower _type in _typeLocations) exitWith { 
            if (!([_position] call FUNC(inSafezones)) && {!COMPARE_STR(_name,"")}) then {
                GVAR(locations) pushBack [_name,_position,_size,_type];
            };
        };
        if (toLower _type in _typeLocals) exitWith {
            if (!([_position] call FUNC(inSafezones)) && {!COMPARE_STR(_name,"")}) then {
                GVAR(locals) pushBack [_name,_position,_size];
            };
        };
        if (toLower _type in _typeHills) exitWith {
            if !([_position] call FUNC(inSafezones)) then {
                GVAR(hills) pushBack [_position,_size];
            };
        };
        if (toLower _type in _typeMarines) exitWith {
            if (!([_position] call FUNC(inSafezones)) && {!COMPARE_STR(_name,"")}) then {
                GVAR(marines) pushBack [_name,_position,_size];
            };
        };
    };
};

private ["_deletionIndices","_nameNoSpace","_cityCenterA2","_cityCenterA3","_places"];

// update location positions, remove if position not safe

_deletionIndices = [];

{
    // get config city center positions if available
    _nameNoSpace = (_x select 0) splitString " " joinString "";
    _cityCenterA2 = _cfgLocations >> ("ACityC_" + _nameNoSpace);
    _cityCenterA3 = _cfgLocations >> ("CityC_" + _nameNoSpace);

    if (isClass _cityCenterA2) then {
        _position = getArray (_cityCenterA2 >> "position");
        _position set [2,(getTerrainHeightASL _position) max 0];
        _x set [1,_position];
    };
    if (isClass _cityCenterA3) then {
        _position = getArray (_cityCenterA3 >> "position");
        _position set [2,(getTerrainHeightASL _position) max 0];
        _x set [1,_position];
    };

    // check if config position is safe
    if !([_x select 1,SAFE_DIST,0] call FUNC(isPosSafe)) then {
        // find new safe position
        _position = [_x select 1,0,_x select 2,SAFE_DIST,0,-1,[0,360],_x select 1] call FUNC(findPosSafe);
        
        if !(_position isEqualTo (_x select 1)) then {
            _x set [1,_position];  
            TRACE_2("%1 new safe pos %2",_x select 0, _position);
        } else {
            GVAR(locations) set [_forEachIndex, []];
            WARNING_1("removing unsafe location: %1",_x select 0);
        };
    };
} forEach GVAR(locations);

// remove unsafe locations
GVAR(locations) = GVAR(locations) select {!(_x isEqualTo [])};

nil