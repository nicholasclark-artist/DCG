/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

add3DENEventHandler ["onMissionNew", {
    set3DENMissionAttributes [
        ["Intel", "IntelTimeOfChanges", 1800], // only effects the first weather change
        ["Intel", "IntelRainIsForced", true] // allow manual weather settings
    ];
}];