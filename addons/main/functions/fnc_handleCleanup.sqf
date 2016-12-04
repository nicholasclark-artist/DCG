/*
Author:
Nicholas Clark (SENSEI)

Description:
handle cleanup

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define CLEAN_DIST 400

{
	if (local _x && {{alive _x} count (units _x) isEqualTo 0}) then { // only local groups can be deleted
		deleteGroup _x;
	};
	false
} count allGroups;

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
			if ({isPlayer _x} count (crew _obj) isEqualTo 0 && {count ([getPosATL _obj,CLEAN_DIST] call EFUNC(main,getNearPlayers)) isEqualTo 0}) then {
				{deleteVehicle _x} forEach (crew _obj);
				deleteVehicle _obj;
			};
		} else {
			if (count ([getPosATL _obj,CLEAN_DIST] call EFUNC(main,getNearPlayers)) isEqualTo 0) then {
				deleteVehicle _obj;
			};
		};
	};
};
