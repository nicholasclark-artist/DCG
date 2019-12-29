/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(init);
PREP(getForecast);
PREP(getOvercast);
PREP(getRain);
PREP(getFog);
PREP(getTemperature);
PREP(getHumidity);
PREP(getDewPoint);
PREP(handleForecast);
PREP(handleRain);
PREP(handleDebug);

GVAR(waiting) = false;
GVAR(cycle) = 0;

// climate measurements
GVAR(temperatureCurrent) = 0;
GVAR(humidityCurrent) = 0;

// initial weather
GVAR(date) = [0,0,0,0,0];
GVAR(overcast) = -1;
GVAR(rain) = -1;
GVAR(fog) = -1;

// weather forecast
GVAR(overcastForecast) = 0;
GVAR(rainForecast) = 0;
GVAR(fogForecast) = 0;

// get map data,default to Altis
_world = ["Altis",worldName] select (isClass (configFile >> "CfgWorlds" >> worldName >> QGVARMAIN(clouds)));

GVAR(temperatureDay) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(temperatureDay));
GVAR(temperatureNight) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(temperatureNight));
GVAR(humidity) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(humidity));
GVAR(clouds) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(clouds));
GVAR(precipitation) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(precipitation));
GVAR(rainfall) = getArray (configFile >> "CfgWorlds" >> _world >> QGVARMAIN(rainfall));

// get overcast probabilities
GVAR(clouds) = GVAR(clouds) apply {1 - _x};

// headless client exit 
if (!isServer) exitWith {};

SETTINGS_INIT;