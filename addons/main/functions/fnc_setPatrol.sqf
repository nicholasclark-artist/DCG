/*
Author:
Nicholas Clark (SENSEI)

Description:
set units on patrol

Arguments:
0: array of units <ARRAY>
1: max distance from original position a unit will patrol <NUMBER>
2: patrol as group or individual <BOOL>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define MINRANGE _range*0.4
#define WAYPOINT_UNITREADY !(behaviour _unit isEqualTo "COMBAT")
#define WAYPOINT_POS (_waypoint select 0)
#define WAYPOINT_TIME (_waypoint select 1)
#define WAYPOINT_TIMEMAX (_waypoint select 2)
#define WAYPOINT_RESETPOS _waypoint set [0,[]]
#define WAYPOINT_RESETTIME _waypoint set [1,0]; _waypoint set [2,0]
#define WAYPOINT_EMPTY [[],0,0]
#define WAYPOINT_ADD(DIST) _waypoint set [0,_pos]; _waypoint set [1,diag_tickTime]; _waypoint set [2,((getpos _unit distance2D _pos)/DIST)*60]
#define WAYPOINT_BUFFER 5

private ["_pos","_grp","_posStart","_type","_d","_r","_roads","_veh","_road","_houses","_housePosArray"];
params ["_units",["_range",100],["_individual",true]];

if (_units isEqualTo []) exitWith {false};

{
    _x setBehaviour "SAFE";
    _waypoint = WAYPOINT_EMPTY;

    if !(_individual) exitWith {
        // check if units are in same group
        _grp = group _x;
        {
            if !(group _x isEqualTo _grp) exitWith { // if a unit is not in the same group, regroup all units
                _grp = [_units,side _grp] call FUNC(setSide);
                _grp setBehaviour "SAFE";
            };
            false
        } count _units;

        leader _grp forceSpeed (leader _grp getSpeed "SLOW");

        [{
            params ["_args","_idPFH"];
            _args params ["_unit","_posStart","_range","_waypoint","_type"];

            if (!alive _unit || {_unit getVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),false]}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                _unit forceSpeed (_unit getSpeed "AUTO");
                LOG_DEBUG_2("%1 exiting patrol at %2.", _type, getPosASL _unit);
            };

            if (WAYPOINT_UNITREADY) then {
                if !(WAYPOINT_POS isEqualTo []) then { // unit has a waypoint
                    if (CHECK_DIST2D(WAYPOINT_POS,_unit,WAYPOINT_BUFFER)) then { // unit is close enough to waypoint, delete waypoint
                        WAYPOINT_RESETPOS;
                        WAYPOINT_RESETTIME;
                    };
                };
                if (_waypoint isEqualTo WAYPOINT_EMPTY || {diag_tickTime >= (WAYPOINT_TIME + WAYPOINT_TIMEMAX)}) then { // if unit near waypoint or unit did not reach waypoint in time, find new waypoint
                    // TODO add code to reset units when they get stuck
                    _d = random 360;
                    _r = floor (random ((_range - MINRANGE) + 1)) + MINRANGE;
                    _pos = [(_posStart select 0) + (sin _d) * _r, (_posStart select 1) + (cos _d) * _r, 0];
                    if !(surfaceIsWater _pos) then {
                        _unit move _pos;
                        WAYPOINT_ADD(100);
                    };
                };
            };
        }, 30, [leader _grp,getPosATL leader _grp,_range,_waypoint,typeOf (vehicle _x)]] call CBA_fnc_addPerFrameHandler;
    };

    if (!((vehicle _x) isEqualTo _x) && {_x isEqualTo (driver (vehicle _x))}) then { // if unit is in a vehicle and is the driver
        _veh = vehicle _x;
        _veh allowCrewInImmobile true;
        _veh addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}];
        _roads = [];

        if !(_veh isKindOf "AIR") then {
            _roads = (getPosATL _x) nearRoads (_range min 1000);
            _veh forceSpeed (_veh getSpeed "SLOW");
        } else {
            _veh forceSpeed (_veh getSpeed "NORMAL");
            _veh flyInHeight 150;
        };

        [{
            params ["_args","_idPFH"];
            _args params ["_unit","_posStart","_range","_waypoint","_roads","_type"];

            _veh = vehicle _unit;

            if (!alive _veh || {!alive _unit} || {_unit getVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),false]}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                _veh forceSpeed (_veh getSpeed "AUTO");
                LOG_DEBUG_2("%1 exiting patrol at %2.",_type,getPosASL _veh);
            };

            if (WAYPOINT_UNITREADY) then {
                if !(WAYPOINT_POS isEqualTo []) then { // unit has a waypoint
                    if (CHECK_DIST2D(WAYPOINT_POS,_unit,WAYPOINT_BUFFER)) then { // unit is close enough to waypoint, delete waypoint
                        WAYPOINT_RESETPOS;
                        WAYPOINT_RESETTIME;
                        LOG_DEBUG_3("CHECK 1 %1 %2 %3",_waypoint,_unit,_veh);
                    };
                };
                if (_waypoint isEqualTo WAYPOINT_EMPTY || {diag_tickTime >= (WAYPOINT_TIME + WAYPOINT_TIMEMAX)}) then { // if unit near waypoint or unit did not reach waypoint in time, find new waypoint
                    if (_roads isEqualTo []) then {
                        _d = random 360;
                        _r = floor (random ((_range - MINRANGE) + 1)) + MINRANGE;
                        _pos = [(_posStart select 0) + (sin _d) * _r, (_posStart select 1) + (cos _d) * _r, (getPosATL _unit) select 2];
                        if !(_veh isKindOf "AIR") then {
                            if !(surfaceIsWater _pos) then {
                                _unit doMove _pos;
                                WAYPOINT_ADD(150); // set waypoint array, argumment determines how long unit has to reach waypoint
                            };
                        } else {
                            LOG_DEBUG_3("CHECK 2 %1 %2 %3",_pos,_unit,_veh);
                            _unit doMove _pos;
                            WAYPOINT_ADD(150);
                        };
                    } else {
                        _road = _roads select floor (random (count _roads));
                        _unit doMove (getPosATL _road);
                        WAYPOINT_ADD(150);
                    };
                };
            };
        }, 30, [_x,getPosATL _x,_range,_waypoint,_roads,typeOf (vehicle _x)]] call CBA_fnc_addPerFrameHandler;
    };

    if ((vehicle _x) isEqualTo _x) then { // if unit is on foot
        _x forceSpeed (_x getSpeed "SLOW");
        _houses = (getposATL _x) nearObjects ["house",_range min 1000];

        [{
            params ["_args","_idPFH"];
            _args params ["_unit","_posStart","_range","_waypoint","_houses","_type"];

            if (!alive _unit || {_unit getVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),false]}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                _unit forceSpeed (_unit getSpeed "AUTO");
                LOG_DEBUG_2("%1 exiting patrol at %2.", _type, getPosASL _unit);
            };

            if (WAYPOINT_UNITREADY) then {
                if !(WAYPOINT_POS isEqualTo []) then { // unit has a waypoint
                    if (CHECK_DIST2D(WAYPOINT_POS,_unit,WAYPOINT_BUFFER)) then { // unit is close enough to waypoint, delete waypoint
                        WAYPOINT_RESETPOS;
                        WAYPOINT_RESETTIME;
                    };
                };
                if (_waypoint isEqualTo WAYPOINT_EMPTY || {diag_tickTime >= (WAYPOINT_TIME + WAYPOINT_TIMEMAX)}) then { // if unit near waypoint or unit did not reach waypoint in time, find new waypoint
                    // TODO add code to reset units when they get stuck
                    if (!(_houses isEqualTo []) && {random 1 < 0.5}) then {
                        _housePosArray = [_houses select floor(random (count _houses)), 3] call BIS_fnc_buildingPositions;
                        if !(_housePosArray isEqualTo []) then {
                            _pos = _housePosArray select floor(random (count _housePosArray));
                            _unit doMove _pos;
                            WAYPOINT_ADD(100); // set waypoint array, argumment determines how long unit has to reach waypoint
                        };
                    } else {
                        _d = random 360;
                        _r = floor (random ((_range - MINRANGE) + 1)) + MINRANGE;
                        _pos = [(_posStart select 0) + (sin _d) * _r, (_posStart select 1) + (cos _d) * _r, 0];
                        if !(surfaceIsWater _pos) then {
                            _unit doMove _pos;
                            WAYPOINT_ADD(100);
                        };
                    };
                };
            };
        }, 30, [_x,getPosATL _x,_range,_waypoint,_houses,typeOf (vehicle _x)]] call CBA_fnc_addPerFrameHandler;
    };
} forEach _units;

true