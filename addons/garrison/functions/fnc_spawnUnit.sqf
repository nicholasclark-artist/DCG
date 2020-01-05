/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn units, should not be called directly

Arguments:
0: location <LOCATION>
1: area location <LOCATION>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"
#define SPAWN_DELAY 0.5

params [
    ["_location",locationNull,[locationNull]],
    ["_ao",locationNull,[locationNull]]
];

// get variables 
private _radius = _location getVariable [QGVAR(radius),0];
private _position =+ (_location getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS]); 
_position set [2,0];

// PATROLS

// get patrol unit count based on player count
private _unitCountPatrol = (_location getVariable [QGVAR(type),""]) call {
    if (COMPARE_STR(toLower _this,"outpost")) exitWith {
        [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
    };
    if (COMPARE_STR(toLower _this,"comm")) exitWith {
        [8,16,GVAR(countCoef)] call EFUNC(main,getUnitCount);
    };
    if (COMPARE_STR(toLower _this,"garrison")) then {
        (_ao getVariable [QEGVAR(main,type),""]) call {
            if (COMPARE_STR(toLower _this,"namecitycapital")) exitWith {
                [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
            };
            if (COMPARE_STR(toLower _this,"namecity")) exitWith {
                [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
            };
            if (COMPARE_STR(toLower _this,"namevillage")) exitWith {
                [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
            };

            0
        };
    };
};

// get patrol spawn position in safe area around composition
private _posPatrol = [_position,_radius + 10,_radius + 50,2,0,-1,[0,360],_position getPos [_radius + 20,random 360]] call EFUNC(main,findPosSafe);

// spawn infantry patrol, patrols will navigate outpost exterior and investigate nearby buildings
for "_i" from 1 to floor (1 max (_unitCountPatrol / PATROLSIZE)) do {
    private _grp = [_posPatrol,0,PATROLSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [{(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location"];
            
            // add eventhandlers
            {
                _x setVariable [QGVAR(location),_location];
                _x addEventHandler ["Killed",{
                    _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                    _location call (_location getVariable [QGVAR(onKilled),{}]);
                }]; 
            } forEach (units _grp);

            [QGVAR(updateUnitCount),[_location,count units _grp]] call CBA_fnc_localEvent;
            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            // set group on patrol
            [_grp,getPos _location,random [200,600,800],3,"MOVE","SAFE","YELLOW","LIMITED","STAG COLUMN","if (0.1 > random 1) then {this spawn CBA_fnc_searchNearby}",[5,16,15]] call CBA_fnc_taskPatrol;
        },
        [_grp,_location],
        (SPAWN_DELAY * _unitCountPatrol) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

// get composition buildings with suitable positions  
private _buildings = _position nearObjects ["House",_radius];
_buildings = _buildings select {!((_x buildingPos -1) isEqualTo [])};

if (_buildings isEqualTo []) then {
    WARNING_1("%1 does not have building positions for infantry",_key);
};

_buildings resize (ceil (count _buildings * 0.5));

TRACE_3("",_key,_unitCountPatrol,count _buildings);

// BUILDING INFANTRY

for "_i" from 1 to floor (1 max (count _buildings / PATROLSIZE)) do {
    private _grp = [_position,0,PATROLSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [{(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location","_buildings"];
            
            // garrison infantry 
            private ["_building","_dir"];

            {
                // get building
                _building = selectRandom _buildings;
                _buildings deleteAt (_buildings find _building);

                _dir = random 360;
                _x setFormDir _dir;
                _x setDir _dir;

                if (PROBABILITY(0.75)) then { // garrison building exit
                    _x setPosATL (_building buildingExit 0);
                } else { // garrison building position
                    _x setPosATL selectRandom (_building buildingPos -1);
                };

                // force unit to hold position
                _x forceSpeed 0;
            } forEach (units _grp);

            // add eventhandlers
            {
                _x setVariable [QGVAR(location),_location];
                _x addEventHandler ["Killed",{
                    _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                    _location call (_location getVariable [QGVAR(onKilled),{}]);
                }]; 
            } forEach (units _grp);

            [QGVAR(updateUnitCount),[_location,count units _grp]] call CBA_fnc_localEvent;
            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;
        },
        [_grp,_location,_buildings],
        (SPAWN_DELAY * (count _buildings)) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};



// private ["_unit","_dir"];

// // spawn building infantry
// {
//     _unit = (createGroup [EGVAR(main,enemySide),true]) createUnit [selectRandom ([EGVAR(main,enemySide),0] call EFUNC(main,getPool)),DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];

//     _dir = random 360;
//     _unit setFormDir _dir;
//     _unit setDir _dir;

//     if (PROBABILITY(0.75)) then { // garrison building exit
//         _unit setPosATL (_x buildingExit 0);
//     } else { // garrison building position
//         _unit setPosATL selectRandom (_x buildingPos -1);
//     };

//     // add eventhandlers
//     _unit setVariable [QGVAR(location),_location];
//     _unit addEventHandler ["Killed",{
//         _location = (_this select 0) getVariable [QGVAR(location),locationNull];
//         _location call (_location getVariable [QGVAR(onKilled),{}]);
//     }]; 

//     [QEGVAR(cache,enableGroup),group _unit] call CBA_fnc_serverEvent;
//     [QGVAR(updateUnitCount),[_location,1]] call CBA_fnc_localEvent;
//     [QGVAR(updateGroups),[_location,group _unit]] call CBA_fnc_localEvent;
// } forEach _buildings;

// COMPOSITION INFANTRY

// private ["_posInf","_unit","_dir"];

// // spawn infantry outside buildings
// for "_i" from 0 to (floor (_radius / 4) min 16) do {
//     _posInf = [_position,0,_radius * 0.9,2,-1,-1,[0,360],_position] call EFUNC(main,findPosSafe);

//     // avoid units stacking at composition pivot
//     if !(_posInf isEqualTo _position) then {
//         _unit = (createGroup [EGVAR(main,enemySide),true]) createUnit [selectRandom ([EGVAR(main,enemySide),0] call EFUNC(main,getPool)),DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
        
//         _dir = random 360;
//         _unit setFormDir _dir;
//         _unit setDir _dir;
//         _unit setPosASL _posInf;

//         // add eventhandlers and vars
//         _unit setVariable [QGVAR(location),_location];
//         _unit addEventHandler ["Killed",{
//             _location = (_this select 0) getVariable [QGVAR(location),locationNull];
//             _location call (_location getVariable [QGVAR(onKilled),{}]);
//         }];

//         [QEGVAR(cache,enableGroup),group _unit] call CBA_fnc_serverEvent;
//         [QGVAR(updateUnitCount),[_location,1]] call CBA_fnc_localEvent;
//         [QGVAR(updateGroups),[_location,group _unit]] call CBA_fnc_localEvent;
//     };
// };

nil