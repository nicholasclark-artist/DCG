/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isMultiplayer) exitWith {};

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
            if (!([_position] call EFUNC(safezone,inAreaAll)) && {!COMPARE_STR(_name,"")}) then {
                GVAR(locations) pushBack [_name,_position,_size,_type];
            };
        };
        if (toLower _type in _typeLocals) exitWith {
            if (!([_position] call EFUNC(safezone,inAreaAll)) && {!COMPARE_STR(_name,"")}) then {
                GVAR(locals) pushBack [_name,_position,_size];
            };
        };
        if (toLower _type in _typeHills) exitWith {
            if !([_position] call EFUNC(safezone,inAreaAll)) then {
                GVAR(hills) pushBack [_position,_size];
            };
        };
        if (toLower _type in _typeMarines) exitWith {
            if (!([_position] call EFUNC(safezone,inAreaAll)) && {!COMPARE_STR(_name,"")}) then {
                GVAR(marines) pushBack [_name,_position,_size];
            };
        };
    };
};

{
    // update locations with center positions if available
    // @todo improve conditional checks 
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
    if !([_x select 1,2,0] call FUNC(isPosSafe)) then {
        _places = selectBestPlaces [_x select 1, (_x select 2)*0.5, "(1 + houses) * (1 - sea)", 35, 4];
        _places = _places select {(_x select 1) > 0 && {[_x select 0,2,0] call FUNC(isPosSafe)}};

        // @todo remove location if safe position not found
        if !(_places isEqualTo []) then {
            _position = (selectRandom _places) select 0;
            _position set [2,(getTerrainHeightASL _position) max 0];
            _x set [1,_position];
        };
    };
} forEach GVAR(locations);

// create world size position grid
GVAR(grid) = [EGVAR(main,center),worldSize/round(worldSize/1000),worldSize,0,0,0] call FUNC(findPosGrid);

[FUNC(handleCleanup), 120, []] call CBA_fnc_addPerFrameHandler;

if !(isNil {HEADLESSCLIENT}) then {
    [{
        {
            deleteGroup _x; // will only delete local empty groups
        } forEach allGroups;
    }, 120, []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler),owner HEADLESSCLIENT,false];
};

// save event handlers
QGVAR(saveDataPVEH) addPublicVariableEventHandler {call FUNC(saveData)};
QGVAR(deleteDataPVEH) addPublicVariableEventHandler {
    profileNamespace setVariable [QGVAR(saveData),nil];
    saveProfileNamespace;
};

// debug event handlers 
QGVAR(debugMarkers) addPublicVariableEventHandler {
    if (GVAR(debug)) then {[1] call FUNC(debug)};
};

// set client actions
[[],{
    if (hasInterface) then {
        {
            _x call EFUNC(main,setAction);
        } forEach [
            [QGVARMAIN(actions),format["%1 Actions",toUpper QUOTE(PREFIX)],{},{true},{},[],player,1,["ACE_SelfActions"]],
            [QGVARMAIN(data),"Mission Data"],
            [QGVAR(saveData),SAVE_ACTION_NAME,{SAVE_ACTION_STATEMENT},{SAVE_ACTION_COND},{},[],player,1,["ACE_SelfActions",QGVARMAIN(actions),QGVARMAIN(data)]],
            [QGVAR(deleteSaveData),SAVE_ACTION_NAME_DELETE,{SAVE_ACTION_STATEMENT_DELETE},{SAVE_ACTION_COND_DELETE},{},[],player,1,["ACE_SelfActions",QGVARMAIN(actions),QGVARMAIN(data)]]
        ];
    };
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];

// everything that needs to run after CBA settings are adjusted (post briefing)
[
    {CHECK_POSTBRIEFING},
    {
        // autosave handler 
        [{
            if (GVAR(autoSave)) then {call FUNC(saveData)};
        }, 1800, []] call CBA_fnc_addPerFrameHandler;

        // load saved data
        _data = [QUOTE(ADDON)] call FUNC(loadDataAddon);
        [_data] call FUNC(handleLoadData);
    }
] call CBA_fnc_waitUntilAndExecute;

MAIN_ADDON = true;
publicVariable QUOTE(MAIN_ADDON);