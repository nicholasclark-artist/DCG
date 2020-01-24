/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn areas, should not be called directly and must be spawned

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(spawnArea)
#define SPAWN_DELAY (1 max 0.1)
#define SHIP_CARGO_COUNT 1

// define scope to break hash loop
scopeName SCOPE;

private ["_positions","_positionsLand","_positionsWater","_grp","_count"];

[GVAR(areas),{
    // get land and water positions 
    _positions = _value getVariable [QGVAR(patrolPositions),[]];

    _positionsLand = _positions select {!(surfaceIsWater _x)};
    _positionsWater = _positions select {surfaceIsWater _x && {(getTerrainHeightASL _x) <= -10}};

    _positionsLand = _positionsLand call BIS_fnc_arrayShuffle;
    _positionsWater = _positionsWater call BIS_fnc_arrayShuffle;

    _positionsLand resize (count _positionsLand min PAT_LIMIT);
    _positionsWater resize (count _positionsWater min PAT_LIMIT_WATER);

    _count = (PAT_GRPSIZE * (count _positionsLand)) max 1;

    // infantry patrols
    {
        _grp = [_x,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                params ["_grp","_value"];

                [QGVAR(updateGroups),[_value,_grp]] call CBA_fnc_localEvent;

                // set group on patrol
                [_grp,getPosATL leader _grp,PAT_SPACING,0,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
            },
            [_grp,_value],
            (SPAWN_DELAY * _count) * 2
        ] call CBA_fnc_waitUntilAndExecute;

        // _mrk = createMarker [format["%1",_forEachIndex + (random 10000)],_x];
        // _mrk setMarkerType "mil_dot";
        // _mrk setMarkerColor "ColorUNKNOWN";

        sleep (SPAWN_DELAY * PAT_GRPSIZE);
    } forEach _positionsLand;

    _count = (count _positionsWater) max 1;

    // ship patrols
    {
        _grp = [_x,1,-1,EGVAR(main,enemySide),SPAWN_DELAY,SHIP_CARGO_COUNT] call EFUNC(main,spawnGroup);

        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                params ["_grp","_value"];

                [QGVAR(updateGroups),[_value,_grp]] call CBA_fnc_localEvent;

                // set group on patrol
                [_grp,getPosATL leader _grp,1000,0] call EFUNC(main,taskPatrol);

                // // infinite fuel
                (objectParent leader _grp) addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}];
            },
            [_grp,_value],
            (SPAWN_DELAY * _count) * 2
        ] call CBA_fnc_waitUntilAndExecute;

        // _mrk = createMarker [format["%1",_forEachIndex + (random 10000)],_x];
        // _mrk setMarkerType "mil_dot";
        // _mrk setMarkerColor "ColorBLUE";

        sleep (SPAWN_DELAY * SHIP_CARGO_COUNT);
    } forEach _positionsWater;
}] call CBA_fnc_hashEachPair;

nil