/*
Author:
Nicholas Clark (SENSEI)

Description:
init occupy addon

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

// run after settings init
if (!EGVAR(main,settingsInitFinished)) exitWith {
    EGVAR(main,runAtSettingsInitialized) pushBack [FUNC(init), _this];
};

private _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

if !(_data isEqualTo []) then {
    [_data] call FUNC(findLocation);
} else {
    [] call FUNC(findLocation);
};

nil