/*
Author:
Nicholas Clark (SENSEI)

Description:
set units on patrol

Arguments:
0: array of units <ARRAY>
1: max distance from original position a unit will patrol or max distance from previous position if group patrol <NUMBER>
2: patrol as group or individual <BOOL>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define PATROL_VAR QUOTE(DOUBLES(PREFIX,isOnPatrol))
#define MINRANGE _range*0.4
#define WAYPOINT_UNITREADY (!(behaviour _unit isEqualTo "COMBAT") && {simulationEnabled _unit})
#define WAYPOINT_POS (_waypoint select 0)
#define WAYPOINT_TIME (_waypoint select 1)
#define WAYPOINT_BUFFER (_waypoint select 2)
#define WAYPOINT_RESET _waypoint set [0,[]]; _waypoint set [1,0]; _waypoint set [2,0]
#define WAYPOINT_EMPTY [[],0,0]
#define WAYPOINT_ADD(DIST) _waypoint set [0,_pos]; _waypoint set [1,diag_tickTime + (((_unit distance2D _pos)/DIST)*60)]; _waypoint set [2,((_unit distance2D _pos)*0.1) max 5]

private ["_pos","_grp","_posStart","_type","_d","_r","_roads","_veh","_road","_houses","_housePosArray"];
params ["_units",["_range",100],["_individual",true],["_behavior","SAFE"]];

if (_units isEqualTo []) exitWith {false};

{
    if !(_individual) exitWith { // group patrol
        _grp = group _x;
        {
            if !(group _x isEqualTo _grp) exitWith { // place all units in same group
                [_x] joinSilent _grp;
            };
        } forEach _units;

        _grp setBehaviour toUpper (_behavior);
        _posStart = getPosATL (leader _grp);

        private _posPrev = _posStart;

        for "_i" from 0 to (2 + (floor (random 3))) do {
            private _pos = [_posPrev,_range*0.5,_range] call FUNC(findPosSafe);
            _posPrev = ASLToAGL _pos;
            private _waypoint = _grp addWaypoint [ASLToAGL _pos,0];
            _waypoint setWaypointType "MOVE";
            _waypoint setWaypointCompletionRadius 20;

            if (_i isEqualTo 0) then {
                _waypoint setWaypointSpeed "LIMITED";
                _waypoint setWaypointFormation "STAG COLUMN";
            };
        };

        private _waypoint = _grp addWaypoint [_posStart, 0];
        _waypoint setWaypointType "CYCLE";
        _waypoint setWaypointCompletionRadius 20;

        (leader _grp) setVariable [PATROL_VAR,1];

        true
    };

    call {
        _waypoint = WAYPOINT_EMPTY;
        _x setBehaviour toUpper (_behavior);

        if (_x isEqualTo driver objectParent _x) exitWith { // if unit is driver of vehicle
            private _veh = vehicle _x;
            private _roads = [];

            _veh addEventHandler ["Fuel",{if !(_this select 1) then {(_this select 0) setFuel 1}}];
            _veh forceSpeed (_veh getSpeed "NORMAL");

            if (_veh isKindOf "LandVehicle") then {
                _roads = (getPosATL _x) nearRoads (_range min 1000);
                _veh forceSpeed (_veh getSpeed "SLOW");
            };

            if (_veh isKindOf "Air") then {
                _veh flyInHeight 150;
            };

            [{
                params ["_args","_idPFH"];
                _args params ["_unit","_posStart","_range","_waypoint","_roads","_type"];

                _veh = vehicle _unit;

                if (!alive _veh || {!alive _unit} || {_unit getVariable [PATROL_VAR,-1] isEqualTo 0}) exitWith {
                    [_idPFH] call CBA_fnc_removePerFrameHandler;
                    _veh forceSpeed (_veh getSpeed "AUTO");
                    LOG_2("%1 exiting patrol at %2.",_type,getPosASL _veh);
                };

                if (WAYPOINT_UNITREADY) then {
                    if !(WAYPOINT_POS isEqualTo []) then { // unit has a waypoint
                        if (CHECK_DIST2D(WAYPOINT_POS,_unit,WAYPOINT_BUFFER)) then { // unit is close enough to waypoint, delete waypoint
                            WAYPOINT_RESET;
                        };
                    };
                    if (_waypoint isEqualTo WAYPOINT_EMPTY || {diag_tickTime >= WAYPOINT_TIME}) then { // if unit near waypoint or unit did not reach waypoint in time, find new waypoint
                        if (_roads isEqualTo []) then {
                            _d = random 360;
                            _r = floor (random ((_range - MINRANGE) + 1)) + MINRANGE;
                            _pos = [(_posStart select 0) + (sin _d) * _r, (_posStart select 1) + (cos _d) * _r, (getPosATL _unit) select 2];
                            if (_veh isKindOf "LandVehicle") then {
                                if !(surfaceIsWater _pos) then {
                                    _unit doMove _pos;
                                    WAYPOINT_ADD(250); // set waypoint array, argument determines how long unit has to reach waypoint
                                };
                            } else {
                                if (_veh isKindOf "Ship") then {
                                    if (surfaceIsWater _pos) then {
                                        _unit doMove _pos;
                                        WAYPOINT_ADD(250); // set waypoint array, argument determines how long unit has to reach waypoint
                                    };
                                } else {
                                    _unit doMove _pos;
                                    WAYPOINT_ADD(500);
                                };
                            };
                        } else {
                            _pos = getPosATL (selectRandom _roads);
                            _unit doMove _pos;
                            WAYPOINT_ADD(250);
                        };
                    };
                };
            }, 20, [_x,getPosATL _x,_range,_waypoint,_roads,typeOf (vehicle _x)]] call CBA_fnc_addPerFrameHandler;

            _x setVariable [PATROL_VAR,1];
        };

        if (isNull (objectParent _x)) exitWith { // if unit is on foot
            _x forceSpeed (_x getSpeed "SLOW");
            private _houses = (getposATL _x) nearObjects ["house",_range min 1000];

            [{
                params ["_args","_idPFH"];
                _args params ["_unit","_posStart","_range","_waypoint","_houses","_type"];

                if (!alive _unit || {_unit getVariable [PATROL_VAR,-1] isEqualTo 0}) exitWith {
                    [_idPFH] call CBA_fnc_removePerFrameHandler;
                    _unit forceSpeed (_unit getSpeed "AUTO");
                    LOG_2("%1 exiting patrol at %2.", _type, getPosASL _unit);
                };

                if (WAYPOINT_UNITREADY) then {
                    if !(WAYPOINT_POS isEqualTo []) then { // unit has a waypoint
                        if (CHECK_DIST2D(WAYPOINT_POS,_unit,WAYPOINT_BUFFER)) then { // unit is close enough to waypoint, delete waypoint
                            WAYPOINT_RESET;
                        };
                    };
                    if (_waypoint isEqualTo WAYPOINT_EMPTY || {diag_tickTime >= WAYPOINT_TIME}) then { // if unit near waypoint or unit did not reach waypoint in time, find new waypoint
                        // TODO add code to reset units when they get stuck
                        if (!(_houses isEqualTo []) && {random 1 < 0.5}) then {
                            private _housePosArray = (selectRandom _houses) buildingPos -1;
                            if !(_housePosArray isEqualTo []) then {
                                _pos = selectRandom _housePosArray;
                                _unit doMove _pos;
                                WAYPOINT_ADD(100); // set waypoint array, argument determines how long unit has to reach waypoint
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

            _x setVariable [PATROL_VAR,1];
        };
    };
} forEach _units;

true