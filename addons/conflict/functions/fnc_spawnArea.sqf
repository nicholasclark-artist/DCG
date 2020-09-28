/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn ao's with patrols, should not be called directly and must run in scheduled environment

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SPAWN_DELAY 1

private ["_location","_polygon","_length","_spacing","_positions","_positionsLand","_positionsWater","_grp"];

// areas don't use FUNC(spawnUnit) because they need specific spawn positions
[GVAR(areas),{
    _polygon = _value getVariable [QEGVAR(main,polygon),[]];

    // get patrol spawn positions
    _length = [_polygon] call EFUNC(main,polygonLength);
    _spacing = _length / round (_length / (AO_INF_GRPSPACING min (_length * 0.5)));

    _positions = [[_polygon,1] call EFUNC(main,polygonCenter),_spacing,_length] call EFUNC(main,findPosGrid);
    _positions = _positions select {[_x select 0,_x select 1,0] inPolygon _polygon};

    // get land and water positions
    _positionsLand = _positions select {!(surfaceIsWater _x)};
    _positionsWater = _positions select {surfaceIsWater _x && {(getTerrainHeightASL _x) <= -10}};

    _positionsLand = _positionsLand call BIS_fnc_arrayShuffle;
    _positionsWater = _positionsWater call BIS_fnc_arrayShuffle;

    _positionsLand resize (count _positionsLand min AO_INF_GRPLIMIT);
    _positionsWater resize (count _positionsWater min AO_SHIP_GRPLIMIT);

    // infantry patrols
    {
        _grp = [_x,0,AO_INF_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

        [QGVAR(updateGroups),[_value,_grp]] call CBA_fnc_localEvent;

        [
            {_this getVariable [QEGVAR(main,ready),false]},
            {
                [_this,getPosATL leader _this,AO_INF_GRPSPACING * 0.6,0,"if (0.1 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
            },
            _grp,
            (SPAWN_DELAY * AO_INF_GRPSIZE) * 2
        ] call CBA_fnc_waitUntilAndExecute;

        // _mrk = createMarker [format["%1",_forEachIndex + (random 10000)],_x];
        // _mrk setMarkerType "mil_dot";
        // _mrk setMarkerColor "ColorUNKNOWN";

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * AO_INF_GRPSIZE);
    } forEach _positionsLand;

    // ship patrols
    {
        _grp = [_x,1,-1,EGVAR(main,enemySide),SPAWN_DELAY,AO_SHIP_CARGO] call EFUNC(main,spawnGroup);

        [QGVAR(updateGroups),[_value,_grp]] call CBA_fnc_localEvent;

        // infinite fuel
        (objectParent leader _grp) addEventHandler ["Fuel",{
            if !(_this select 1) then {(_this select 0) setFuel 1};
        }];

        [
            {_this getVariable [QEGVAR(main,ready),false]},
            {
                [_this,getPosATL leader _this,1000,0] call EFUNC(main,taskPatrol);
            },
            _grp,
            (SPAWN_DELAY * ((count _positionsWater) max 1)) * 2
        ] call CBA_fnc_waitUntilAndExecute;

        // _mrk = createMarker [format["%1",_forEachIndex + (random 10000)],_x];
        // _mrk setMarkerType "mil_dot";
        // _mrk setMarkerColor "ColorBLUE";

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * AO_SHIP_CARGO);
    } forEach _positionsWater;
}] call CBA_fnc_hashEachPair;

nil