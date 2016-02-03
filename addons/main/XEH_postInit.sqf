/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define BASE_VAR DOUBLES(PREFIX,base)
#define CREATE_BASE(BASE_POS) \
	GVAR(baseLocation) = createLocation ["NameCity", BASE_POS, GVAR(baseRadius), GVAR(baseRadius)]; \
	GVAR(baseLocation) setText format ["%1", GVAR(baseName)]
#define DEFAULTPOS [-5000,-5000]
#define CREATE_DEFAULT_BASE \
	GVAR(baseLocation) = createLocation ["NameCity", DEFAULTPOS, 100, 100]

if (!isServer || !isMultiplayer) exitWith {};

if (CHECK_MARKER(QUOTE(BASE_VAR))) then { // check if base marker exists
	CREATE_BASE(getMarkerPos QUOTE(BASE_VAR));
	{CREATE_BASE(getMarkerPos QUOTE(BASE_VAR));} remoteExecCall ["BIS_fnc_call",-2,true]; // can't PV locations, so recreate location on clients. Runs at time > 0

	[{
		GVAR(baseLocation) setPosition (getMarkerPos QUOTE(BASE_VAR));
	}, 1, []] call CBA_fnc_addPerFrameHandler;
} else {
	if !(isNil QUOTE(BASE_VAR)) then { // check if base object exists
		CREATE_BASE(getPos BASE_VAR);
		{CREATE_BASE(getPos BASE_VAR);} remoteExecCall ["BIS_fnc_call",-2,true]; // can't PV locations, so recreate location on clients. Runs at time > 0
		[{
			GVAR(baseLocation) setPosition (getPos BASE_VAR);
		}, 1, []] call CBA_fnc_addPerFrameHandler;
	};
};

if (isNull GVAR(baseLocation)) then {
	CREATE_DEFAULT_BASE;
	{CREATE_DEFAULT_BASE;} remoteExecCall ["BIS_fnc_call",-2,true];
	LOG_DEBUG_1("Base marker does not exist. Creating default MOB location at %1.",DEFAULTPOS);
};

// get map locations
{
	_name = text _x;
	_position = locationPosition _x;
	_position set [2, abs (_position select 2)]; // gets actual positionASL, not ASL altitude zero
	_size = (((size _x) select 0) + ((size _x) select 1))/2;
	_type = type _x;

	if (!(CHECK_DIST2D(_position,locationPosition GVAR(baseLocation),GVAR(baseRadius))) && {!(_name in GVAR(blacklistLocations))} && {!(_name isEqualTo "")}) then {
		GVAR(locations) pushBack [_name,_position,_size,_type];
	};
} forEach (nearestLocations [GVAR(center), ["NameCityCapital","NameCity","NameVillage"], GVAR(range)]);

// safezone PFH
if (GVAR(baseSafezone)) then {
	[{
		{
			if (side _x isEqualTo GVAR(enemySide) && {!isPlayer _x}) then {
				deleteVehicle (vehicle _x);
				deleteVehicle _x;
			};
		} forEach (locationPosition GVAR(baseLocation) nearEntities [["Man","LandVehicle","Ship","Air"], GVAR(baseRadius)]);
	}, 60, []] call CBA_fnc_addPerFrameHandler;
};

// cleanup PFH
if (GVAR(cleanup)) then {
	if !(isNil {HEADLESSCLIENT}) then {
		{
			[{
				{
					if (local _x && {{alive _x} count (units _x) isEqualTo 0}) then { // only local groups can be deleted
						deleteGroup _x;
					};
				} forEach allGroups;
			}, 30, []] call CBA_fnc_addPerFrameHandler;
		} remoteExecCall ["bis_fnc_call", owner HEADLESSCLIENT];
	};

	[{
		private ["_obj"];
		// groups
		{
			if (local _x && {{alive _x} count (units _x) isEqualTo 0}) then { // only local groups can be deleted
				deleteGroup _x;
			};
		} forEach allGroups;
		// markers
		if !(EGVAR(main,markerCleanup) isEqualTo []) then {
			for "_i" from (count EGVAR(main,markerCleanup) - 1) to 0 step -1 do {
				deleteMarker (EGVAR(main,markerCleanup) select _i);
				EGVAR(main,markerCleanup) deleteAt _i;
			};
		};
		// objects
		if !(EGVAR(main,objectCleanup) isEqualTo []) then {
			for "_i" from (count EGVAR(main,objectCleanup) - 1) to 0 step -1 do {
				_obj = EGVAR(main,objectCleanup) select _i;
				if (_obj isKindOf "LandVehicle" || {_obj isKindOf "Air"} || {_obj isKindOf "Ship"}) then {
					if ({isPlayer _x} count (crew _obj) isEqualTo 0 && {count ([getPosATL _obj,300] call EFUNC(main,getNearPlayers)) isEqualTo 0}) then {
						{deleteVehicle _x} forEach (crew _obj);
						deleteVehicle _obj;
						EGVAR(main,objectCleanup) deleteAt _i;
					};
				} else {
					if (count ([getPosATL _obj,300] call EFUNC(main,getNearPlayers)) isEqualTo 0) then {
						deleteVehicle _obj;
						EGVAR(main,objectCleanup) deleteAt _i;
					};
				};
			};
		};
		// base items
		{
			if (_x getVariable [QUOTE(DOUBLES(PREFIX,cleanup)),true]) then {deleteVehicle _x};
		} forEach (nearestObjects [locationPosition GVAR(baseLocation),["WeaponHolder","GroundWeaponHolder","WeaponHolderSimulated"],GVAR(baseRadius)]);
	}, 180, []] call CBA_fnc_addPerFrameHandler;
};

// actions
{
	if (hasInterface) then {
		waitUntil {time > 5 && {!isNull (findDisplay 46)} && {!isNull player} && {alive player}}; // fix for "respawn on start" missions
		[QUOTE(DOUBLES(PREFIX,actions)),format["%1 Actions",toUpper QUOTE(PREFIX)],"","true","",player,1,["ACE_SelfActions"]] call FUNC(setAction);
		[QUOTE(DOUBLES(PREFIX,data)),"Mission Data","","true","",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]] call FUNC(setAction);
		[QUOTE(DOUBLES(ADDON,saveData)),"Save Mission Data",QUOTE(call FUNC(saveDataClient)),QUOTE(time > 60 && {isServer || serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]] call FUNC(setAction);
		[QUOTE(DOUBLES(ADDON,deleteSaveData)),"Delete All Saved Mission Data",QUOTE(call FUNC(deleteDataClient)),QUOTE(isServer || {serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]] call FUNC(setAction);
	};
} remoteExec ["BIS_fnc_call",0,true];

// data PVEH
// used to call save function from client
DATA_SAVEPVEH addPublicVariableEventHandler {
	call FUNC(saveData);
};

// used to call delete function from client
DATA_DELETEPVEH addPublicVariableEventHandler {
	profileNamespace setVariable [DATA_SAVEVAR,nil];
	saveProfileNamespace;
};

// AI caching
if (GVAR(cache)) then {
	[2000,0,false,2000,6000,6000] execVM "\d\dcg\addons\main\scripts\zbe_cache\main.sqf";
};

// set mission params as missionNameSpace variables
call FUNC(setParams);

ADDON = true;
publicVariable QUOTE(ADDON);