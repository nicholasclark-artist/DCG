/*
Author:
Nicholas Clark (SENSEI)

Description:
init approval addon

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define REGION_SIZE (worldSize/(1 max (round(worldSize/GVAR(regionSize)))))

// run after settings init
if (!EGVAR(main,settingsInitFinished)) exitWith {
    EGVAR(main,runAtSettingsInitialized) pushBack [FUNC(init), _this];
};

private ["_data", "_value", "_location"];

// load saved data
_data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

// create approval regions
{
    _value = if (count _data > _forEachIndex + 1) then {
        _data select _forEachIndex
    } else {
        AP_DEFAULT
    };

    _location = createLocation ["Name", ASLtoAGL _x, REGION_SIZE*0.5, REGION_SIZE*0.5];
    _location setRectangular true;
    _location setVariable [QGVAR(regionValue),_value];
    
    GVAR(regions) pushBack _location;
} forEach ([EGVAR(main,center),REGION_SIZE,worldSize] call EFUNC(main,findPosGrid));

// start hostile handler after one cooldown cycle
[{
    [FUNC(handleHostile), GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler;
}, [], GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

nil