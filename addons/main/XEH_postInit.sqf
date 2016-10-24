/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define BASE DOUBLES(PREFIX,base)
#define DEFAULTPOS [-5000,-5000]
#define CREATE_BASE \
	GVAR(baseLocation) = createLocation ["NameCity", getPos BASE, GVAR(baseRadius), GVAR(baseRadius)]; \
	GVAR(baseLocation) setText GVAR(baseName); \
	GVAR(baseLocation) attachObject BASE
#define CREATE_DEFAULTBASE GVAR(baseLocation) = createLocation ["NameCity", DEFAULTPOS, 10, 10]

if !(CHECK_INIT) exitWith {};

if (CHECK_MARKER(QUOTE(BASE))) then {
	BASE = "Land_HelipadEmpty_F" createVehicle [0,0,0];
	BASE setPos (getMarkerPos QUOTE(BASE));
	publicVariable QUOTE(BASE);
};

if !(isNil QUOTE(BASE)) then {
	CREATE_BASE;
	{
		CREATE_BASE;
	} remoteExecCall [QUOTE(BIS_fnc_call),-2,true];
};

if (isNull GVAR(baseLocation)) then {
	CREATE_DEFAULTBASE;
	{
		CREATE_DEFAULTBASE;
	} remoteExecCall [QUOTE(BIS_fnc_call),-2,true];

	WARNING_1("Base object does not exist. Base location created at %1.",DEFAULTPOS);
};

_mrk = createMarker [QUOTE(DOUBLES(PREFIX,baseMrk)),locationPosition GVAR(baseLocation)];
_mrk setMarkerBrush "Border";
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [GVAR(baseRadius), GVAR(baseRadius)];
[_mrk] call EFUNC(main,setDebugMarker);

// get map locations from config
_cfgLocations = configFile >> "CfgWorlds" >> worldName >> "Names";
_typeLocations = ["namecitycapital","namecity","namevillage"];
_typeLocals = ["namelocal"];
_typeHills = ["hill"];
_typeMarines = ["namemarine"];

for "_i" from 0 to (count _cfgLocations) - 1 do {
	_location = _cfgLocations select _i;
	_type = getText (_location >> "type");
	_name = getText (_location >> "name");
	_position = getArray (_location >> "position");
	_position set [2,(getTerrainHeightASL _position) max 0];
	_size = ((getNumber (_location >> "radiusA")) + (getNumber (_location >> "radiusB")))*0.5;

	call {
		if (toLower _type in _typeLocations) exitWith {
			if (!(CHECK_DIST2D(_position,locationPosition GVAR(baseLocation),GVAR(baseRadius))) && {{COMPARE_STR(_x,_name)} count GVAR(blacklistLocations) isEqualTo 0} && {!(_name isEqualTo "")}) then {
				GVAR(locations) pushBack [_name,_position,_size,_type];
			};
		};
		if (toLower _type in _typeLocals) exitWith {
			if (!(CHECK_DIST2D(_position,locationPosition GVAR(baseLocation),GVAR(baseRadius))) && {!(_name isEqualTo "")}) then {
				GVAR(locals) pushBack [_name,_position,_size];
			};
		};
		if (toLower _type in _typeHills) exitWith {
			if !(CHECK_DIST2D(_position,locationPosition GVAR(baseLocation),GVAR(baseRadius))) then {
				GVAR(hills) pushBack [_position,_size];
			};
		};
		if (toLower _type in _typeMarines) exitWith {
			if (!(CHECK_DIST2D(_position,locationPosition GVAR(baseLocation),GVAR(baseRadius))) && {!(_name isEqualTo "")}) then {
				GVAR(marines) pushBack [_name,_position,_size];
			};
		};
	};
};

{
	// update locations with center positions if available
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

	// update locations with safe positions
	if !([_x select 1,0.5,0] call FUNC(isPosSafe)) then {
		_places = selectBestPlaces [_x select 1, _x select 2, "(1 + houses) * (1 - sea)", 35, 4];
		_places = _places select {(_x select 1) > 0 && {[_x select 0,0.5,0] call FUNC(isPosSafe)}};

		if !(_places isEqualTo []) then {
			_position = (selectRandom _places) select 0;
			_position set [2,(getTerrainHeightASL _position) max 0];
			_x set [1,_position];
		};
	};
	false
} count GVAR(locations);

if (GVAR(baseSafezone)) then {
	[FUNC(handleSafezone), 60, []] call CBA_fnc_addPerFrameHandler;
};

// set cleanup handlers
[FUNC(handleCleanup), 60, []] call CBA_fnc_addPerFrameHandler;

if !(isNil {HEADLESSCLIENT}) then {
	[{
		{
			if (local _x && {{alive _x} count (units _x) isEqualTo 0}) then {
				deleteGroup _x;
			};
		} forEach allGroups;
	}, 10, []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler),owner HEADLESSCLIENT,false];
};

// set client actions
[[],{
	if (hasInterface) then {
		[
			{!isNull player && {alive player} && {!isNil {DOUBLES(PREFIX,main)}} && {DOUBLES(PREFIX,main)}},
			{
				{
					_x call EFUNC(main,setAction);
				} forEach [
					[QUOTE(DOUBLES(PREFIX,actions)),format["%1 Actions",toUpper QUOTE(PREFIX)],"",QUOTE(true),"",player,1,["ACE_SelfActions"]],
					[QUOTE(DOUBLES(PREFIX,data)),"Mission Data","",QUOTE(true),""],
					[QUOTE(DOUBLES(ADDON,saveData)),"Save Mission Data",QUOTE(call FUNC(saveDataClient)),QUOTE(time > 60 && {isServer || serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]],
					[QUOTE(DOUBLES(ADDON,deleteSaveData)),"Delete All Saved Mission Data",QUOTE(call FUNC(deleteDataClient)),QUOTE(isServer || {serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]]
				];
			}
		] call CBA_fnc_waitUntilAndExecute;
	};
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];

// save functionality
if (GVAR(autoSave)) then {
	[
		{
			[{
				call FUNC(saveData);
			}, 900, []] call CBA_fnc_addPerFrameHandler;
		},
		[],
		900
	] call CBA_fnc_waitAndExecute;
};

DATA_SAVEPVEH addPublicVariableEventHandler {
	call FUNC(saveData);
};

DATA_DELETEPVEH addPublicVariableEventHandler {
	profileNamespace setVariable [DATA_SAVEVAR,nil];
	saveProfileNamespace;
};

// load data
_data = QUOTE(ADDON) call FUNC(loadDataAddon);
[_data] call FUNC(handleLoadData);

ADDON = true;
publicVariable QUOTE(ADDON);
