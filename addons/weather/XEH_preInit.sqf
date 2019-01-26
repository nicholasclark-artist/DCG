/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(init);
PREP(getOvercast);
PREP(getRain);
PREP(handleForecast);

GVAR(date) = [2013,9,12,7,0];
GVAR(overcast) = 0;
GVAR(rain) = 0;
GVAR(fog) = 0;
GVAR(cycle) = 0;

// get world data, default to Altis
_world = ["Altis", worldName] select (isClass (configFile >> "CfgWorlds" >> worldName >> QGVARMAIN(cloudCover)));

GVAR(cloudCover) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(cloudCover));
GVAR(precipitation) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(precipitation));
GVAR(rainfall) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(rainfall));

SETTINGS_INIT;