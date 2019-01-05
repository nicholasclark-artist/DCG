/*
Author:
Nicholas Clark (SENSEI)

Description:
save data to server profile

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define PUSHBACK_DATA(ADDONTOSAVE,DATATOSAVE) \
    LOG_2("Saving %1: %2.",QGVARMAIN(ADDONTOSAVE),DATATOSAVE); \
    GVAR(saveDataScenario) pushBack [QGVARMAIN(ADDONTOSAVE),DATATOSAVE]

if !(isServer) exitWith {};

// overwrite current data
GVAR(saveDataScenario) = [SAVE_SCENARIO_ID];

// MAIN ADDON
if (CHECK_ADDON_2(main)) then {
    private _data = [];

    {
        // @todo add support for saving units
        if (_x getVariable [QGVAR(saveEntity),false] && {!(_x isKindOf "MAN")}) then {
            _entity = _x;

            // save entity variables if "dcg" found in string
            private _vars = (allVariables _entity) select {(_x find QUOTE(PREFIX)) >= 0};

            // set as [variable name, variable value]
            {
                _vars set [_forEachIndex,[_x,_entity getVariable _x]];	
            } forEach _vars;

            _data pushBack [typeOf _x,getPosASL _x,getDir _x,vectorUp _x,_vars];
        };
    } foreach (allMissionObjects "All");

    PUSHBACK_DATA(main,_data);
};

// OCCUPY ADDON
if (CHECK_ADDON_2(occupy)) then {
    private _data = [];

    EGVAR(occupy,location) params ["_name","_position","_size","_type"];

    private _infCount = 0;
    private _vehCount = 0;
    private _airCount = 0;

    { 
        if ((driver _x) getVariable [QEGVAR(occupy,saveEntity),false]) then { 
            if (_x isKindOf "Man") exitWith {
                _infCount = _infCount + 1;
            };
            if (_x isKindOf "LandVehicle") exitWith {
                _vehCount = _vehCount + 1;
            };
            if (_x isKindOf "Air") exitWith {
                _airCount = _airCount + 1;
            };
        };
    } forEach (_position nearEntities [["Man","LandVehicle","Air"],_size*1.5]);

    _data append [_name,_position,_size,_type,[_infCount,_vehCount,_airCount]];

    PUSHBACK_DATA(occupy,_data);
};

// FOB ADDON
if (CHECK_ADDON_2(fob)) then {
    private _data = [];

    if !(EGVAR(fob,location) isEqualTo locationNull) then {
        _data pushBack (locationPosition EGVAR(fob,location));
        _data pushBack (curatorPoints EGVAR(fob,curator));
        private _dataObj = [];
        private _refund = 0;
        {
            if (!(_x isKindOf "Man") && {!(_x isKindOf "Logic")} && {count crew _x isEqualTo 0}) then {
                _dataObj pushBack [typeOf _x,getPosASL _x,getDir _x,vectorUp _x];
            } else {
                call {
                    if (_x isKindOf "Man") exitWith {
                        _refund = _refund + abs(COST_MAN*EGVAR(fob,deleteCoef));
                    };
                    if (_x isKindOf "Car") exitWith {
                        _refund = _refund + abs(COST_CAR*EGVAR(fob,deleteCoef));
                    };
                    if (_x isKindOf "Tank") exitWith {
                        _refund = _refund + abs(COST_TANK*EGVAR(fob,deleteCoef));
                    };
                    if (_x isKindOf "Air") exitWith {
                        _refund = _refund + abs(COST_AIR*EGVAR(fob,deleteCoef));
                    };
                    if (_x isKindOf "Ship") exitWith {
                        _refund = _refund + abs(COST_SHIP*EGVAR(fob,deleteCoef));
                    };
                };
            };
        } forEach (curatorEditableObjects EGVAR(fob,curator));

        _data pushBack _dataObj;
        _refund = ((_data select 1) + _refund) min 1;
        _data set [1,_refund];
        //_data pushBack [EGVAR(fob,AVBonus)];
    };

    PUSHBACK_DATA(fob,_data);
};

// WEATHER ADDON
if (CHECK_ADDON_2(weather)) then {
    private _data = [overcast,date];

    PUSHBACK_DATA(weather,_data);
};

/* 
// IED ADDON
if (CHECK_ADDON_2(ied)) then {
    private _data = [];
    {
        private _pos = getPos _x;
        _pos resize 2;
        _data pushBack _pos;
        false
    } count EGVAR(ied,list);

    PUSHBACK_DATA(ied,_data);
}; 
*/

// TASK ADDON
if (CHECK_ADDON_2(task)) then {
    private _data = [EGVAR(task,primary),EGVAR(task,secondary)];

    PUSHBACK_DATA(task,_data);
};

// APPROVAL ADDON
if (CHECK_ADDON_2(approval)) then {
    private _data = [];

    {
        _data pushBack (_x getVariable QEGVAR(approval,regionValue));
    } forEach EGVAR(approval,regions);

    PUSHBACK_DATA(approval,_data);
};

// following code must run last
private _dataProfile = SAVE_GETVAR;

if !(_dataProfile isEqualTo []) then {
    // only replace data for current scenario
    {
        if ((_x select 0) == SAVE_SCENARIO_ID) exitWith {
            _dataProfile set [_forEachIndex,GVAR(saveDataScenario)];
        };
        _dataProfile pushBack GVAR(saveDataScenario);
    } forEach _dataProfile;
} else {
    _dataProfile pushBack GVAR(saveDataScenario);
};

SAVE_SETVAR(_dataProfile);
saveProfileNamespace;
