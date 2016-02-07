/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn emplacements

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define DEBUG_MRK \
	if (CHECK_DEBUG) then { \
		_mrk = createMarker [format["%1_static_%2",QUOTE(PREFIX),getposATL _gunner],getposATL _gunner]; \
		_mrk setMarkerType "o_installation"; \
		_mrk setMarkerColor format ["Color%1",side _gunner]; \
		_mrk setMarkerSize [0.7,0.7]; \
	}

private ["_mrk","_gunner","_pos","_range","_count","_side","_objArray","_gunnerArray","_posArray","_unit","_static1","_static2","_static3","_type","_tower","_roads","_road","_roadConnectedTo","_staticPos","_check","_bunker","_dir","_static","_fort","_fortPos"];

_pos = param [0];
_range = param [1,100,[0]];
_count = param [2,1,[0]];
_side = param [4,GVAR(enemySide)];

_objArray = [];
_gunnerArray = [];
_posArray = [_pos,50,_range,0,7] call FUNC(findPosGrid);

call {
	if (_side isEqualTo EAST) exitWith {
		_unit = selectRandom GVAR(unitPoolEast);
		_static1 = "Land_Cargo_Patrol_V1_F";
		_static2 = "O_HMG_01_high_F";
		_static3 = "O_Mortar_01_F";
	};
	if (_side isEqualTo WEST) exitWith {
		_unit = selectRandom GVAR(unitPoolWest);
		_static1 = "Land_Cargo_Patrol_V1_F";
		_static2 = "B_HMG_01_high_F";
		_static3 = "B_Mortar_01_F";
	};
	_unit = selectRandom GVAR(unitPoolInd);
	_static1 = "Land_Cargo_Patrol_V1_F";
	_static2 = "I_HMG_01_high_F";
	_static3 = "I_Mortar_01_F";
};

{
	if (count _gunnerArray isEqualTo _count) exitWith {};

	if !(isOnRoad _x) then {
		_type = ceil random 3;
		if (_type isEqualTo 1) exitWith { // tower
			_tower = _static1 createVehicle _x;
			_tower setdir ([_tower, _pos] call BIS_fnc_DirTo) + 180;
			_tower setvectorup [0,0,1];
			_gunner = (createGroup _side) createUnit [_unit, [0,0,0], [], 0, "NONE"];
			_gunner setFormDir (getDir _tower);
			_gunner setDir (getDir _tower);
			_gunner setPosATL (_tower buildingpos 1);
			_gunner setUnitPos "UP";
			_gunner disableAI "MOVE";
			_gunner setSkill ["spotDistance",0.90];
			_gunnerArray pushBack _gunner;
			_objArray pushBack _tower;
			DEBUG_MRK;
		};
		if (_type isEqualTo 2) exitWith { // bunkered static
			_roads = _x nearRoads _range;
			if (_roads isEqualTo []) exitWith {};
			_road = selectRandom _roads;
			_roadConnectedTo = (roadsConnectedTo _road);
			if (_roadConnectedTo isEqualTo []) exitWith {};
			_roadConnectedTo = _roadConnectedTo select 0;
			_staticPos = _road modelToWorld [-11,0,0];
			_staticPos set [2,0];
			_check = _staticPos isFlatEmpty [2, 0, 0.4, 3, 0, false, objNull];
			if (_check isEqualTo [] || {isOnRoad _staticPos}) exitWith {};
			_staticPos set [2,-0.02];
			_bunker = "Land_BagBunker_Small_F" createVehicle _staticPos;
			_dir = [_road, _roadConnectedTo] call BIS_fnc_DirTo;
			_bunker setDir _dir + 180;
			_bunker setVectorUp surfaceNormal position _bunker;
			if (count (lineIntersectsObjs [[(getposasl _bunker) select 0,(getposasl _bunker) select 1,((getposasl _bunker) select 2) + 1], ATLToASL(_bunker modelToWorld [0,30,1])]) > 0) exitWith {deleteVehicle _bunker};
			_static = createVehicle [_static2,[0,0,0], [], 0, "CAN COLLIDE"];
			_static setPosATL (_bunker modelToWorld [0,0,-0.8]);
			_gunner = (createGroup _side) createUnit [_unit, [0,0,0], [], 0, "NONE"];
			_gunner moveInGunner _static;
			_gunner doWatch (_bunker modelToWorld [0,-40,1]);
			_gunnerArray pushBack _gunner;
			_objArray pushBack _bunker;
			_objArray pushBack _static;
			DEBUG_MRK;
		};
		 // mortar
		 if !(_x isFlatEmpty [2, 0, 0.4, 3, 0, false, objNull] isEqualTo []) then {
			_static = _static3 createVehicle _x;
			_fort = "Land_BagFence_Round_F" createVehicle [0,0,0];
			_fortPos = (_static modelToWorld [0,2.3,0]);
			_fortPos set [2,0];
			_fort setPosATL _fortPos;
			_fort setDir ([_fort, _static] call BIS_fnc_DirTo);
			_fort setVectorUp surfaceNormal position _fort;
			_objArray pushBack _fort;
			_fort = "Land_BagFence_Round_F" createVehicle [0,0,0];
			_fortPos = (_static modelToWorld [0,-2.3,0]);
			_fortPos set [2,0];
			_fort setPosATL _fortPos;
			_fort setDir ([_fort, _static] call BIS_fnc_DirTo);
			_fort setVectorUp surfaceNormal position _fort;
			_objArray pushBack _fort;
			_fort = "Land_BagFence_Round_F" createVehicle [0,0,0];
			_fortPos = (_static modelToWorld [-2.3,0,0]);
			_fortPos set [2,0];
			_fort setPosATL _fortPos;
			_fort setDir ([_fort, _static] call BIS_fnc_DirTo);
			_fort setVectorUp surfaceNormal position _fort;
			_objArray pushBack _fort;
			_objArray pushBack _static;
			_gunner = (createGroup _side) createUnit [_unit, [0,0,0], [], 0, "NONE"];
			_gunner moveInGunner _static;
			_gunnerArray pushBack _gunner;
			DEBUG_MRK;
		 };
	};
} forEach _posArray;

[_gunnerArray,_objArray]