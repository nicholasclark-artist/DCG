/*
Author:
Nicholas Clark (SENSEI)

Description:
parse location hashes for civilian handling

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define LOCATION_COND GVAR(blacklist) findIf {(toLower _key) find _x > -1} < 0 && {!([_value select 0] call EFUNC(main,inSafezones))}

// convert blacklist to array and format
GVAR(blacklist) = GVAR(blacklist) splitString ",";
GVAR(blacklist) = GVAR(blacklist) apply {toLower _x};

// get locations for unit spawns
private ["_locations","_arr"];

_locations = [];

// get data from main location hashes
[
    EGVAR(main,locations),
    {
        if (LOCATION_COND) then {
            _arr = [];
            _arr pushBack _key;
            _arr append _value;
            _locations pushBack _arr;
        };
    }
] call CBA_fnc_hashEachPair;

[
    EGVAR(main,locals),
    {
        if (LOCATION_COND) then {
            _arr = [];
            _arr pushBack _key;
            _arr append _value;
            _locations pushBack _arr;
        };
    }
] call CBA_fnc_hashEachPair;

private ["_hash","_location","_buildingPositions","_mrk"];

_hash = [];

for "_i" from 0 to (count _locations - 1) do {
    (_locations select _i) params ["_name","_position","_radius"];

    // find houses with building positions 
    // @todo add eventhandler to buildings to remove house from buildingPos array when destroyed
    _buildingPositions = (ASLToAGL _position nearObjects ["House", _radius min 300]) apply {_x buildingPos -1} select {count _x > 0};

    if (count _buildingPositions > 1) then {
        // create location
        _location = createLocation ["Invisible",ASLToAGL _position,_radius,_radius];
        _location setText _name;

        // onCreated / onDeleted unit code
        _onCreate = {
            TRACE_1("spawn",_this);

            // headless client / cache support
            _this setVariable [QEGVAR(main,HCBlacklist), true];
            _this setVariable ["acex_headless_blacklist", true];

            // behaviors 
            _this setSkill 0.1;
            _this setUnitPos "UP";
            _this forceSpeed (_this getSpeed "SLOW");
            _this setBehaviour "CARELESS";

            {_this disableAI _x} forEach ["FSM","AUTOTARGET","TARGET","WEAPONAIM","AIMINGERROR","SUPPRESSION","CHECKVISIBLE","COVER","AUTOCOMBAT","MINEDETECTION"];
            
            // animations
            _this setAnimSpeedCoef (0.8 + random 0.2);

            // loadout
            removeAllWeapons _this;
        };

        _onDelete = {

        };

        // get ambient anim objects 
        private _animObjects = nearestTerrainObjects [ASLToAGL _position,["HIDE"],_radius,false];
        _animObjects = _animObjects select {((getModelInfo _x) select 0) find "chair" > -1 || ((getModelInfo _x) select 0) find "bench" > -1};   
        _animObjects = _animObjects select {round (vectorUp _x select 0) isEqualTo 0 && {round (vectorUp _x select 1) isEqualTo 0} && {round (vectorUp _x select 2) isEqualTo 1}};

        // set variables
        _location setVariable [QGVAR(animObjects),_animObjects];
        _location setVariable [QGVAR(buildingPositions),_buildingPositions];
        _location setVariable [QGVAR(prefabCount),ceil (count _buildingPositions * 0.1)];
        _location setVariable [QGVAR(unitCount),((ceil (count _buildingPositions * 0.25)) + 1) min GVAR(unitLimit)];
        _location setVariable [QGVAR(vehicleCount),ceil random 6];
        _location setVariable [QGVAR(onCreate),_onCreate];
        _location setVariable [QGVAR(onDelete),_onDelete];
        _location setVariable [QGVAR(zdist),CIV_ZDIST];

        // reset these variables on location cleanup
        _location setVariable [QGVAR(active),false];
        _location setVariable [QGVAR(moveToPositions),[]];
        _location setVariable [QGVAR(prefabPositions),[]];
        _location setVariable [QGVAR(units),[]];
        _location setVariable [QGVAR(ambients),[]];

        // debug markers
        _mrk = createMarker [[QUOTE(PREFIX),_name] joinString "_",_position];
        _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "Border";
        _mrk setMarkerSize [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist)];
        [_mrk] call EFUNC(main,setDebugMarker);     

        // add to location hash
        _hash pushBack [_name,_location];     
    } else {
        WARNING_3("unsuitable spawn location: %1: %2: %3",_name,_position,count _buildingPositions);
    };
};

// create location hash
GVAR(locations) = [_hash] call CBA_fnc_hashCreate;

nil