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
#define SCOPE QGVAR(parseMapLocations)
#define SAFE_DIST 2
#define SAFE_RADIUS 50
#define INDEX_KEY 0
#define INDEX_VALUE 1
#define VORONOI_DEBUG 0
#define VORONOI_DEBUG_CTRL (findDisplay 12 displayCtrl 51)
#define VORONOI_SEARCH_RADIUS 300

scopeName SCOPE;

// get map locations from config
private _cfgLocations = configFile >> "CfgWorlds" >> worldName >> "Names";

if (count _cfgLocations isEqualTo 0) exitWith {
    ERROR_1("%1 does not have config locations",worldName);
};

private _typeLocations = ["namecitycapital","namecity","namevillage"];
private _typeLocals = ["namelocal"];
private _typeHills = ["hill"];
private _typeMarines = ["namemarine"];

private ["_mapLocation","_location","_type","_name","_position","_radius","_ret","_positionSafe","_nameNoSpace","_cityCenterA2","_cityCenterA3","_check"];

for "_i" from 0 to (count _cfgLocations) - 1 do {
    _mapLocation = _cfgLocations select _i;
    _type = getText (_mapLocation >> "type");
    _name = getText (_mapLocation >> "name");
    _position = getArray (_mapLocation >> "position");
    _position set [2,ASLZ(_position)];
    _radius = ((getNumber (_mapLocation >> "radiusA")) + (getNumber (_mapLocation >> "radiusB")))*0.5;

    _check = true;
    _location = locationNull;

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

                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,0] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,0,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        _position = _positionSafe;
                    } else {
                        _check = false;
                        WARNING_1("removing location. unsafe position: %1",_name);
                    };
                };
                
                // get accurate radius from building density
                if (_check) then {
                    _radius = [_position] call FUNC(findLocationRadius);

                    if (_radius < 1) then {
                        _check = false;
                        WARNING_1("removing location. bad radius: %1",_name);
                    };
                };

                // create hash location
                if (_check) then {
                    _location = createLocation ["Invisible",ASLtoAGL _position,1,1];

                    _location setVariable [QGVAR(name),_name];
                    _location setVariable [QGVAR(configName),configName _mapLocation];
                    _location setVariable [QGVAR(type),_type];
                    _location setVariable [QGVAR(positionASL),_position];
                    _location setVariable [QGVAR(radius),_radius];
                    _location setVariable [QGVAR(mapLocation),nearestLocation [ASLtoAGL _position,_type]];
                };

                GVAR(locations) pushBack [_name,_location];
            };
        };
        if (toLower _type in _typeLocals) exitWith {
            if (!COMPARE_STR(_name,"") && {!([_position] call FUNC(inSafezones))}) then {
                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,0] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,0,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        _position = _positionSafe;
                    } else {
                        _check = false;
                        WARNING_1("removing local. unsafe position: %1",_name);
                    };
                };

                // create hash location
                if (_check) then {
                    _location = createLocation ["Invisible",ASLtoAGL _position,1,1];

                    _location setVariable [QGVAR(name),_name];
                    _location setVariable [QGVAR(configName),configName _mapLocation];
                    _location setVariable [QGVAR(type),_type];
                    _location setVariable [QGVAR(positionASL),_position];
                    _location setVariable [QGVAR(radius),_radius];
                    _location setVariable [QGVAR(mapLocation),nearestLocation [ASLtoAGL _position,_type]];
                };

                // use config name because several locals share names
                GVAR(locals) pushBack [configName _mapLocation,_location];
            };
        };
        if (toLower _type in _typeHills) exitWith {
            if !([_position] call FUNC(inSafezones)) then {
                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,0] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,0,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        _position = _positionSafe;
                    } else {
                        _check = false;
                        WARNING_1("removing hill. unsafe position: %1",configName _mapLocation);
                    };
                };

                // create hash location
                if (_check) then {
                    _location = createLocation ["Invisible",ASLtoAGL _position,1,1];

                    _location setVariable [QGVAR(name),_name];
                    _location setVariable [QGVAR(configName),configName _mapLocation];
                    _location setVariable [QGVAR(type),_type];
                    _location setVariable [QGVAR(positionASL),_position];
                    _location setVariable [QGVAR(radius),_radius];
                    _location setVariable [QGVAR(mapLocation),nearestLocation [ASLtoAGL _position,_type]];
                };

                GVAR(hills) pushBack [configName _mapLocation,_location];
            };
        };
        if (toLower _type in _typeMarines) exitWith {
            if (!([_position] call FUNC(inSafezones)) && {!COMPARE_STR(_name,"")}) then {
                // check if config position is safe
                if !([ASLtoAGL _position,SAFE_DIST,2] call FUNC(isPosSafe)) then {
                    // find new safe position
                    _positionSafe = [_position,0,SAFE_RADIUS,SAFE_DIST,2,-1,[0,360],_position] call FUNC(findPosSafe);
                    
                    if !(_positionSafe isEqualTo _position) then {
                        _position = _positionSafe;
                    } else {
                        _check = false;
                        WARNING_1("removing marine. unsafe position: %1",_name);
                    };
                };

                // create hash location
                if (_check) then {
                    _location = createLocation ["Invisible",ASLtoAGL _position,1,1];

                    _location setVariable [QGVAR(name),_name];
                    _location setVariable [QGVAR(configName),configName _mapLocation];
                    _location setVariable [QGVAR(type),_type];
                    _location setVariable [QGVAR(positionASL),_position];
                    _location setVariable [QGVAR(radius),_radius];
                    _location setVariable [QGVAR(mapLocation),nearestLocation [ASLtoAGL _position,_type]];
                };

                GVAR(marines) pushBack [_name,_location];
            };
        };
    };
};

// remove unsafe positions 
GVAR(locations) = GVAR(locations) select {!(isNull (_x select INDEX_VALUE))};
GVAR(locals) = GVAR(locals) select {!(isNull (_x select INDEX_VALUE))};
GVAR(hills) = GVAR(hills) select {!(isNull (_x select INDEX_VALUE))};
GVAR(marines) = GVAR(marines) select {!(isNull (_x select INDEX_VALUE))};

// convert to hashes
// KVP: ["",[]]
GVAR(locations) = [GVAR(locations), locationNull] call CBA_fnc_hashCreate;
GVAR(locals) = [GVAR(locals), locationNull] call CBA_fnc_hashCreate;
GVAR(hills) = [GVAR(hills), locationNull] call CBA_fnc_hashCreate;
GVAR(marines) = [GVAR(marines), locationNull] call CBA_fnc_hashCreate;

if (!isMultiplayer && {!is3DEN}) exitWith {}; // exit if not in multiplayer or editor

// create voronoi diagram
private _sites = [];

// get sites from location hash
[GVAR(locations),{
    private _site =+ (_value getVariable [QGVAR(positionASL),[]]);
    _sites pushBack _site;
}] call CBA_fnc_hashEachPair;

// set as position2D
{_x resize 2} forEach _sites;

// generate diagram
private _dT = diag_tickTime;
private _voronoi = [_sites, worldSize, worldSize] call FUNC(getEdges);
private _execTime = diag_tickTime - _dT;

TRACE_3("voronoi diagram",count _sites,count _voronoi,_execTime);

// draw debug
if (VORONOI_DEBUG > 0) then {
    GVAR(voronoi) = _voronoi;

    [] spawn {
        waitUntil {!isNull VORONOI_DEBUG_CTRL};
        GVAR(voronoiDebugDraw) = VORONOI_DEBUG_CTRL ctrlAddEventHandler [
            "Draw",
            {
                GVAR(voronoi) apply {
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

// ad polygon to hash location
private ["_edgeStart","_edgeEnd","_locationL","_locationR","_keyL","_keyR","_valueL","_valueR"];

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
    if ([GVAR(locations),_keyL] call CBA_fnc_hashHasKey) then {
        _valueL = ([GVAR(locations),_keyL] call CBA_fnc_hashGet) getVariable [QGVAR(polygon),[]];
        _valueL pushBackUnique _edgeStart;
        _valueL pushBackUnique _edgeEnd;

        ([GVAR(locations),_keyL] call CBA_fnc_hashGet) setVariable [QGVAR(polygon),_valueL];
    };

    if ([GVAR(locations),_keyR] call CBA_fnc_hashHasKey) then {
        _valueR = ([GVAR(locations),_keyR] call CBA_fnc_hashGet) getVariable [QGVAR(polygon),[]];
        _valueR pushBackUnique _edgeStart;
        _valueR pushBackUnique _edgeEnd;

        ([GVAR(locations),_keyR] call CBA_fnc_hashGet) setVariable [QGVAR(polygon),_valueR];
    };
} forEach _voronoi;

// sort polygon vertices
[GVAR(locations),{
    _value setVariable [QGVAR(polygon),[_value getVariable [QGVAR(polygon),[]]] call FUNC(polygonSort)];
}] call CBA_fnc_hashEachPair;

// check convexity
[GVAR(locations),{
    if !([_value getVariable [QGVAR(polygon),[]]] call FUNC(polygonIsConvex)) then {
        ERROR_1("%1 polygon is not convex. removing from hash",_key);
        [GVAR(locations),_key] call CBA_fnc_hashRem;
    };
}] call CBA_fnc_hashEachPair;

nil