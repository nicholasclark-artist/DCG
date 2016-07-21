/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define BASE DOUBLES(PREFIX,base)
#define DEFAULTPOS [-5000,-5000]

if (!isServer || !isMultiplayer) exitWith {};

/*[QGVAR(addPlayerActions), {
	[
		{!isNull player && {alive player} && {!isNil {DOUBLES(PREFIX,main)}} && {DOUBLES(PREFIX,main)}},
		{
			{
				_x call EFUNC(main,setAction);
			} forEach (_this select 0);
		},
		[_this]
	] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addEventHandler;*/

[QGVAR(setLocationText), {(_this select 0) setText (_this select 1)}] call CBA_fnc_addEventHandler;
[QGVAR(deleteLocation), {deleteLocation (_this select 0)}] call CBA_fnc_addEventHandler;
[QGVAR(playMoveNow), {(_this select 0) playMoveNow (_this select 1)}] call CBA_fnc_addEventHandler;

[QGVAR(createBase), {
	if (isNull GVAR(baseLocation)) then {
		GVAR(baseLocation) = createLocation ["NameCity", getPos BASE, GVAR(baseRadius), GVAR(baseRadius)];
		GVAR(baseLocation) setText GVAR(baseName);
		GVAR(baseLocation) attachObject BASE;
	};
}] call CBA_fnc_addEventHandler;

[QGVAR(createDefaultBase), {
	if (isNull GVAR(baseLocation)) then {
		GVAR(baseLocation) = createLocation ["NameCity", DEFAULTPOS, 10, 10];
	};
}] call CBA_fnc_addEventHandler;

[QGVAR(cleanupGrpPFH), {
	[{
		{
			if (local _x && {{alive _x} count (units _x) isEqualTo 0}) then {
				deleteGroup _x;
			};
		} forEach allGroups;
	}, 10, []] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_addEventHandler;

// set mission params as missionNameSpace variables
call FUNC(setParams);

if (CHECK_MARKER(QUOTE(BASE))) then {
	BASE = "Land_HelipadEmpty_F" createVehicle (getMarkerPos QUOTE(BASE));
	publicVariable QUOTE(BASE);
};

if !(isNil QUOTE(BASE)) then {
	[QGVAR(createBase),[]] call CBA_fnc_localEvent;
	[QGVAR(createBase),[]] call CBA_fnc_globalEventJIP;
};

if (isNull GVAR(baseLocation)) then {
	[QGVAR(createDefaultBase),[]] call CBA_fnc_localEvent;
	[QGVAR(createDefaultBase),[]] call CBA_fnc_globalEventJIP;
	LOG_DEBUG_1("Base object does not exist. Base location created at %1.",DEFAULTPOS);
};

GVAR(blacklistLocations) = GVAR(blacklistLocations) apply {toLower _x};
GVAR(simpleWorlds) = GVAR(simpleWorlds) apply {toLower _x};

// get map locations
// allows for user create locations
{
	_name = text _x;
	_position = locationPosition _x;
	_position set [2, abs (_position select 2)]; // gets actual positionASL, not ASL altitude zero
	_size = (((size _x) select 0) + ((size _x) select 1))/2;
	_type = type _x;

	if (!(CHECK_DIST2D(_position,locationPosition GVAR(baseLocation),GVAR(baseRadius))) && {!(toLower _name in GVAR(blacklistLocations))} && {!(_name isEqualTo "")}) then {
		GVAR(locations) pushBack [_name,_position,_size,_type];
	};
} forEach (nearestLocations [GVAR(center), ["NameCityCapital","NameCity","NameVillage"], GVAR(range)]);

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

if !(isNil {HEADLESSCLIENT}) then {
	[QGVAR(cleanupGrpPFH), [], HEADLESSCLIENT] call CBA_fnc_targetEvent;
};

[{
	private ["_obj"];

	{
		if (local _x && {{alive _x} count (units _x) isEqualTo 0}) then { // only local groups can be deleted
			deleteGroup _x;
		};
	} forEach allGroups;

	if !(GVAR(markerCleanup) isEqualTo []) then {
		for "_i" from (count GVAR(markerCleanup) - 1) to 0 step -1 do {
			deleteMarker (GVAR(markerCleanup) select _i);
			GVAR(markerCleanup) deleteAt _i;
		};
	};

	if !(GVAR(objectCleanup) isEqualTo []) then {
		GVAR(objectCleanup) = GVAR(objectCleanup) select {!isNull _x}; // remove null elements
		for "_i" from (count GVAR(objectCleanup) - 1) to 0 step -1 do {
			_obj = GVAR(objectCleanup) select _i;
			if (_obj isKindOf "LandVehicle" || {_obj isKindOf "Air"} || {_obj isKindOf "Ship"}) then {
				if ({isPlayer _x} count (crew _obj) isEqualTo 0 && {count ([getPosATL _obj,300] call EFUNC(main,getNearPlayers)) isEqualTo 0}) then {
					{deleteVehicle _x} forEach (crew _obj);
					deleteVehicle _obj;
				};
			} else {
				if (count ([getPosATL _obj,300] call EFUNC(main,getNearPlayers)) isEqualTo 0) then {
					deleteVehicle _obj;
				};
			};
		};
	};

	{
		if (_x getVariable [QUOTE(DOUBLES(PREFIX,cleanup)),true]) then {deleteVehicle _x};
	} forEach (nearestObjects [locationPosition GVAR(baseLocation),["WeaponHolder","GroundWeaponHolder","WeaponHolderSimulated"],GVAR(baseRadius)]);
}, 60, []] call CBA_fnc_addPerFrameHandler;

/*[
	QGVAR(addPlayerActions),
	[
		[QUOTE(DOUBLES(PREFIX,actions)),format["%1 Actions",toUpper QUOTE(PREFIX)],"",QUOTE(true),"",player,1,["ACE_SelfActions"]],
		[QUOTE(DOUBLES(PREFIX,data)),"Mission Data","",QUOTE(true),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]],
		[QUOTE(DOUBLES(ADDON,saveData)),"Save Mission Data",QUOTE(call FUNC(saveDataClient)),QUOTE(time > 60 && {isServer || serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]],
		[QUOTE(DOUBLES(ADDON,deleteSaveData)),"Delete All Saved Mission Data",QUOTE(call FUNC(deleteDataClient)),QUOTE(isServer || {serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]]
	]
] call CBA_fnc_globalEventJIP;*/

_actions = 	[
	[QUOTE(DOUBLES(PREFIX,actions)),format["%1 Actions",toUpper QUOTE(PREFIX)],"",QUOTE(true),"",player,1,["ACE_SelfActions"]],
	[QUOTE(DOUBLES(PREFIX,data)),"Mission Data","",QUOTE(true),""],
	[QUOTE(DOUBLES(ADDON,saveData)),"Save Mission Data",QUOTE(call FUNC(saveDataClient)),QUOTE(time > 60 && {isServer || serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]],
	[QUOTE(DOUBLES(ADDON,deleteSaveData)),"Delete All Saved Mission Data",QUOTE(call FUNC(deleteDataClient)),QUOTE(isServer || {serverCommandAvailable '#logout'}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(DOUBLES(PREFIX,data))]]
];

REMOTE_WAITADDACTION(0,_actions,true);

DATA_SAVEPVEH addPublicVariableEventHandler {
	call FUNC(saveData);
};

DATA_DELETEPVEH addPublicVariableEventHandler {
	profileNamespace setVariable [DATA_SAVEVAR,nil];
	saveProfileNamespace;
};

ADDON = true;
publicVariable QUOTE(ADDON);