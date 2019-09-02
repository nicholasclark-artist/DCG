/*
Author:
Nicholas Clark (SENSEI)

Description:
create map location hashes and generate voronoi diagram based on hashes

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SAFE_DIST 2
#define SAFE_RADIUS 50
#define INDEX_KEY 0
#define INDEX_VALUE 1
#define LOCATION_KVP [_name,[_position,_radius,_type]]
#define LOCAL_KVP [_name,[_position,_radius]]
#define HILL_KVP [configName _location, [_position,_radius]]
#define MARINE_KVP [_name,[_position,_radius]]
#define VORONOI_DEBUG 1
#define VORONOI_DEBUG_CTRL (findDisplay 12 displayCtrl 51)
#define VORONOI_SEARCH_RADIUS 300

// get map locations from config
private _cfgLocations = configFile >> "CfgWorlds" >> worldName >> "Names";

if (count _cfgLocations isEqualTo 0) exitWith {
    ERROR_1("%1 does not have config locations",worldName);
};

private _typeLocations = ["namecitycapital","namecity","namevillage"];
private _typeLocals = ["namelocal"];
private _typeHills = ["hill"];
private _typeMarines = ["namemarine"];

private ["_location","_type","_name","_position","_radius","_ret","_positionSafe","_nameNoSpace","_cityCenterA2","_cityCenterA3"];

for "_i" from 0 to (count _cfgLocations) - 1 do {
    _location = _cfgLocations select _i;
    _type = getText (_location >> "type");
    _name = getText (_location >> "name");
    _position = getArray (_location >> "position");
    _position set [2,ASLZ(_position)];
    _radius = ((getNumber (_location >> "radiusA")) + (getNumber (_location >> "radiusB")))*0.5;

    call {
        if (toLower _type in _typeLocations) exitWith { 
            if (!COMPARE_STR(_name,"") && {!([_position] call FUNC(inSafezones))}) then {
                // get config city center positions if available
                _nameNoSpace = _name splitString " " joinString "";
                _cityCenterA2 = _cfgLocations >> ("ACityC_" + _nameNoSpace);
                _cityCenterA3 = _cfgLocations >> ("CityC_" + _nameNoSpace);

                if (isClass _cityCenterA2) then {
                    _position = getArray (_cityCenterA2 >> "position");
                    _position set [2,ASLZ(_position)];
                };
                if (isClass _cityCenterA3) then {
                    _position = getArray (_cityCenterA3 >> "position");
                    _position set [2,ASLZ(_position)];
                }; 
                
                // setup return, key-value pair
                _ret = LOCATION_KVP;

                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,0] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,0,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        (_ret select INDEX_VALUE) set [0,_positionSafe];  
                        // TRACE_2("location safe position",_name,_positionSafe);
                    } else {
                        _ret set [INDEX_VALUE,[]];
                        WARNING_1("removing unsafe location: %1",_name);
                    };
                };
                
                // overwrite radius
                if !((_ret select INDEX_VALUE) isEqualTo []) then {
                    _radius = [_ret select INDEX_VALUE select 0] call FUNC(findLocationRadius);

                    if (_radius > 0) then {
                        (_ret select INDEX_VALUE) set [1,_radius]; 
                    };
                };

                GVAR(locations) pushBack _ret;
            };
        };
        if (toLower _type in _typeLocals) exitWith {
            if (!COMPARE_STR(_name,"") && {!([_position] call FUNC(inSafezones))}) then {
                // setup return, key-value pair
                _ret = LOCAL_KVP;

                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,0] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,0,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        (_ret select INDEX_VALUE) set [0,_positionSafe];  
                        // TRACE_2("local safe position",_name,_positionSafe);
                    } else {
                        _ret set [INDEX_VALUE,[]];
                        WARNING_1("removing unsafe local: %1",_name);
                    };
                };

                GVAR(locals) pushBack _ret;
            };
        };
        if (toLower _type in _typeHills) exitWith {
            if !([_position] call FUNC(inSafezones)) then {
                // setup return, key-value pair
                _ret = HILL_KVP;

                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,0] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,0,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        (_ret select INDEX_VALUE) set [0,_positionSafe];  
                        // TRACE_2("hill safe position",configName _location,_positionSafe);
                    } else {
                        _ret set [INDEX_VALUE,[]];
                        WARNING_1("removing unsafe hill: %1",configName _location);
                    };
                };
                GVAR(hills) pushBack _ret;
            };
        };
        if (toLower _type in _typeMarines) exitWith {
            if (!([_position] call FUNC(inSafezones)) && {!COMPARE_STR(_name,"")}) then {
                // setup return, key-value pair
                _ret = MARINE_KVP;

                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,2] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,2,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        (_ret select INDEX_VALUE) set [0,_positionSafe];    
                        // TRACE_2("marine safe position",_name,_positionSafe);
                    } else {
                        _ret set [INDEX_VALUE,[]];
                        WARNING_1("removing unsafe marine: %1",_name);
                    };
                };

                GVAR(marines) pushBack _ret;
            };
        };
    };
};

// remove unsafe positions 
GVAR(locations) = GVAR(locations) select {!((_x select INDEX_VALUE) isEqualTo [])};
GVAR(locals) = GVAR(locals) select {!((_x select INDEX_VALUE) isEqualTo [])};
GVAR(hills) = GVAR(hills) select {!((_x select INDEX_VALUE) isEqualTo [])};
GVAR(marines) = GVAR(marines) select {!((_x select INDEX_VALUE) isEqualTo [])};

// // sort locations by xpos
// private ["_locationsXPosSort","_polygonIndices","_newValue"];

// _locationsXPosSort = [];
// _polygonIndices = [];
// _newValue = [];

// // sort by xpos
// {
//     _locationsXPosSort pushBack [_x select 1 select 0 select 0,_forEachIndex];
// } forEach GVAR(locations);

// _locationsXPosSort sort true;

// // create new sorted array
// _polygonIndices = _locationsXPosSort apply {_x select 1};
// _newValue resize (count GVAR(locations));

// for "_i" from 0 to (count GVAR(locations)) - 1 do {
//     _newValue set [_i,GVAR(locations) select (_polygonIndices select _i)];
// };

// GVAR(locations) = _newValue;

// convert to hashes
// KVP: ["",[]]
GVAR(locations) = [GVAR(locations), []] call CBA_fnc_hashCreate;
GVAR(locals) = [GVAR(locals), []] call CBA_fnc_hashCreate;
GVAR(hills) = [GVAR(hills), []] call CBA_fnc_hashCreate;
GVAR(marines) = [GVAR(marines), []] call CBA_fnc_hashCreate;

if (!isMultiplayer && {!is3DEN}) exitWith {}; // exit if not in multiplayer or editor

// @todo check if voronoi failed by checking for overlapping polygons

// create voronoi diagram
private _sites = [];

// get sites from location hash
[GVAR(locations),{
    _sites pushBack (_value select 0);
}] call CBA_fnc_hashEachPair;

// set as position2D
_sites =+ _sites;
{_x resize 2} forEach _sites;

// generate diagram
private _dT = diag_tickTime;
private _voronoi = [_sites, worldSize, worldSize] call FUNC(getEdges);
private _execTime = diag_tickTime - _dT;

TRACE_3("",count _sites,count _voronoi,_execTime);

// draw debug
if (VORONOI_DEBUG > 0) then {
    GVAR(voronoiDebugDraw) = _voronoi;

    [] spawn {
        waitUntil {!isNull VORONOI_DEBUG_CTRL};
        VORONOI_DEBUG_CTRL ctrlAddEventHandler [
            "Draw",
            {
                GVAR(voronoiDebugDraw) apply {
                    _x params ["_start", "_end"];

                    private _d = _end getDir _start;
                    private _l = 0.5*(_start distance2D _end);
                    private _a1 = _end getPos [_l min 75, _d+25];
                    private _a2 = _end getPos [_l min 75, _d-25];

                    (_this select 0) drawLine [
                        _start,
                        _end,
                        [1,0,0,1]
                    ];
                    (_this select 0) drawLine [
                        _end,
                        _a1,
                        [1,0,0,1]
                    ];
                    (_this select 0) drawLine [
                        _end,
                        _a2,
                        [1,0,0,1]
                    ];
                    (_this select 0) drawLine [
                        _a1,
                        _a2,
                        [1,0,0,1]
                    ];
                };
            }
        ];
    };
};

// create polygon hash from voronoi diagram
private ["_edgeStart","_edgeEnd","_locationL","_locationR","_keyL","_keyR","_valueL","_valueR"];

// KVP: ["",[]]
GVAR(locationPolygons) = ([GVAR(locations)] call CBA_fnc_hashKeys) apply {[_x,[]]};
GVAR(locationPolygons) = [GVAR(locationPolygons),[]] call CBA_fnc_hashCreate;

{
    _edgeStart =+ _x select 0;
    _edgeStart pushBack 0;

    _edgeEnd =+ _x select 1;
    _edgeEnd pushBack 0;

    // @todo find faster way to get locations associated with edge
    // get locations to the left and right of voronoi edge
    _locationL = [(nearestLocations [_x select 2,_typeLocations,VORONOI_SEARCH_RADIUS]) select 0,locationNull] select ((_x select 2) isEqualTo objNull);
    _locationR = [(nearestLocations [_x select 3,_typeLocations,VORONOI_SEARCH_RADIUS]) select 0,locationNull] select ((_x select 3) isEqualTo objNull);
    
    // get name's of locations, same as hash key
    _keyL = text _locationL;
    _keyR = text _locationR;

    // add edge vertices to polygon hash if location in hash
    if ([GVAR(locationPolygons),_keyL] call CBA_fnc_hashHasKey) then {
        _valueL = [GVAR(locationPolygons),_keyL] call CBA_fnc_hashGet;
        _valueL pushBackUnique _edgeStart;
        _valueL pushBackUnique _edgeEnd;
        [GVAR(locationPolygons),_keyL,_valueL] call CBA_fnc_hashSet;
    };

    if ([GVAR(locationPolygons),_keyR] call CBA_fnc_hashHasKey) then {
        _valueR = [GVAR(locationPolygons),_keyR] call CBA_fnc_hashGet;
        _valueR pushBackUnique _edgeStart;
        _valueR pushBackUnique _edgeEnd;
        [GVAR(locationPolygons),_keyR,_valueR] call CBA_fnc_hashSet;
    };
} forEach _voronoi;

// sort polygon vertices
private ["_newValue"];

[GVAR(locationPolygons),{
    _newValue = [_value] call FUNC(polygonSort);
    [GVAR(locationPolygons),_key,_newValue] call CBA_fnc_hashSet;
}] call CBA_fnc_hashEachPair;

nil