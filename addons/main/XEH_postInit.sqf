/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define CREATE_MOB \
	GVAR(mobLocation) = createLocation ["NameLocal", getMarkerPos QUOTE(DOUBLES(PREFIX,base)), GVAR(mobRadius), GVAR(mobRadius)]; \
	GVAR(mobLocation) setText format ["%1", GVAR(mobName)]

if !(isServer) exitWith {};

if (CHECK_MARKER(QUOTE(DOUBLES(PREFIX,base)))) then {
	CREATE_MOB;
	{CREATE_MOB;} remoteExecCall ["BIS_fnc_call",-2,true]; // can't PV locations, so recreate location on clients. Runs at time > 0
} else {
	LOG_DEBUG("Base marker does not exist. Cannot create MOB location.");
};

// get map locations
{
	_name = text _x;
	_position = locationPosition _x;
	_position set [2, abs (_position select 2)]; // gets actual positionASL, not ASL altitude zero
	_size = (((size _x) select 0) + ((size _x) select 1))/2;
	_type = type _x;

	if (!(CHECK_DIST2D(_position,locationPosition GVAR(mobLocation),GVAR(mobRadius))) && {!(_name in GVAR(blacklistLocations))} && {!(_name isEqualTo "")}) then {
		GVAR(locations) pushBack [_name,_position,_size,_type];
	};
} forEach (nearestLocations [GVAR(center), ["NameCityCapital","NameCity","NameVillage"], GVAR(range)]);

// cleanup PFH
if (GVAR(cleanup)) then {
	if (CHECK_HC) then {
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
		// MOB items
		if !(EGVAR(main,mobLocation) isEqualTo locationNull) then {
			{
				if (_x getVariable [QUOTE(DOUBLES(PREFIX,cleanup)),true]) then {deleteVehicle _x};
			} forEach nearestObjects [locationPosition GVAR(mobLocation),["WeaponHolder","GroundWeaponHolder","WeaponHolderSimulated"],EGVAR(main,mobRadius)];
		};
	}, 180, []] call CBA_fnc_addPerFrameHandler;
};

// actions
{
	if (hasInterface) then {
		waitUntil {time > 5 && {!isNull (findDisplay 46)} && {!isNull player} && {alive player}}; // hack to fix "respawn on start" missions
		[QUOTE(DOUBLES(PREFIX,actions)),format["%1 Actions",toUpper QUOTE(PREFIX)],"","true","",player,1,["ACE_SelfActions"]] call FUNC(setAction);
		[QUOTE(DOUBLES(PREFIX,data)),"Mission Data","","true","",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]] call FUNC(setAction);
		[QUOTE(DOUBLES(ADDON,saveData)),"Save Mission Data",QUOTE(call FUNC(saveDataClient)),QUOTE(isServer || {serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]] call FUNC(setAction);
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