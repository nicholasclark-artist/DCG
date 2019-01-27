/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(init);
PREP(getForecast);
PREP(handleForecast);
PREP(handleRain);

GVAR(waiting) = false;
GVAR(cycle) = 0;

// initial forecast
GVAR(iDate) = [0,0,0,0,0];
GVAR(iOvercast) = 0;
GVAR(iRain) = 0;
GVAR(iFog) = 0;

// mid-mission forecast, weather variance
GVAR(mOvercast) = 0;
GVAR(mRain) = 0;
GVAR(mFog) = 0;

// get world data, default to Altis
_world = ["Altis", worldName] select (isClass (configFile >> "CfgWorlds" >> worldName >> QGVARMAIN(cloudCover)));

GVAR(cloudCover) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(cloudCover));
GVAR(precipitation) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(precipitation));
GVAR(rainfall) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(rainfall));

SETTINGS_INIT;