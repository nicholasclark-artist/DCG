/*
Author:
Nicholas Clark (SENSEI)

Description:
DEPRECATED
export pool data from 3DEN selection

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define PRINT_MSG(MSG) \
    titleText [MSG, "PLAIN"]
#define SAVE_MSG "Saving selected units to mission CBA Settings\nPool: %1\nCount: %2"

private _objects = get3DENSelected "object";

if (_objects isEqualTo []) exitWith {
    PRINT_MSG("Save error - no units in selection")
};

private _testObject = _objects select 0;
private _side = side _testObject;
private _kind = call {
    if (_testObject isKindOf "Man") exitWith {
        "Man"
    };
    if (_testObject isKindOf "LandVehicle") exitWith {
        "LandVehicle"
    };
    if (_testObject isKindOf "Air") exitWith {
        "Air"
    };
    ""
};

if (COMPARE_STR(_kind,"")) exitWith {
    PRINT_MSG("Save error - units are not of allowed types")
};

{
    if (!(_x isKindOf _kind) || {!(side _x isEqualTo _side)}) exitWith {
        _objects = [];
    };
} forEach _objects;

if (_objects isEqualTo []) exitWith {
    PRINT_MSG("Save error - units are not of same type or side")
};

_objects = _objects apply {typeOf _x}; // get classnames from objects
_objects = _objects arrayIntersect _objects; // remove duplicates

call {
    if (_side isEqualTo WEST) exitWith {
        if (_kind isEqualTo "Man") exitWith {
            [QGVAR(unitPoolWest), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"unit pool WEST",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "LandVehicle") exitWith {
            [QGVAR(vehPoolWest), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"vehicle pool WEST",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "Air") exitWith {
            [QGVAR(airPoolWest), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"aircraft pool WEST",count _objects];
            PRINT_MSG(_msg);
        };  

        PRINT_MSG("Save error - units are not of allowed types")
    };

    if (_side isEqualTo EAST) exitWith {
        if (_kind isEqualTo "Man") exitWith {
            [QGVAR(unitPoolEast), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"unit pool EAST",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "LandVehicle") exitWith {
            [QGVAR(vehPoolEast), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"vehicle pool EAST",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "Air") exitWith {
            [QGVAR(airPoolEast), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"aircraft pool EAST",count _objects];
            PRINT_MSG(_msg);
        };  

        PRINT_MSG("Save error - units are not of allowed types")
    };

    if (_side isEqualTo INDEPENDENT) exitWith {
        if (_kind isEqualTo "Man") exitWith {
            [QGVAR(unitPoolInd), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"unit pool INDEPENDENT",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "LandVehicle") exitWith {
            [QGVAR(vehPoolInd), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"vehicle pool INDEPENDENT",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "Air") exitWith {
            [QGVAR(airPoolInd), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"aircraft pool INDEPENDENT",count _objects];
            PRINT_MSG(_msg);
        };  

        PRINT_MSG("Save error - units are not of allowed types")
    };

    if (_side isEqualTo CIVILIAN) exitWith {
        if (_kind isEqualTo "Man") exitWith {
            [QGVAR(unitPoolCiv), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"unit pool CIVILIAN",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "LandVehicle") exitWith {
            [QGVAR(vehPoolCiv), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"vehicle pool CIVILIAN",count _objects];
            PRINT_MSG(_msg);
        };
        if (_kind isEqualTo "Air") exitWith {
            [QGVAR(airPoolCiv), str _objects, true, "mission", true] call CBA_settings_fnc_set;

            _msg = format [SAVE_MSG,"aircraft pool CIVILIAN",count _objects];
            PRINT_MSG(_msg);
        };  

        PRINT_MSG("Save error - units are not of allowed types")
    };

    PRINT_MSG("Save error - units are not of allowed sides")
};

nil