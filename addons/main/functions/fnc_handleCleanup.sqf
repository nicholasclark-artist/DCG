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
#define CLEAN_DIST 500

{
	deleteGroup _x; // will only delete local empty groups
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
        if (_obj getVariable [QGVAR(forceCleanup),false] || {[getPos _obj,CLEAN_DIST] call EFUNC(main,getNearPlayers) isEqualTo []}) then {
            if (_obj isKindOf "LandVehicle" || {_obj isKindOf "Air"} || {_obj isKindOf "Ship"}) then {
                {deleteVehicle _x} forEach (crew _obj);
                deleteVehicle _obj;
    		} else {
    			deleteVehicle _obj;
    		};
        };
	};
};
