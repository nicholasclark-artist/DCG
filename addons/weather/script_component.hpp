#define COMPONENT weather
#define COMPONENT_PRETTY Weather

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define WEATHER_DELAY (1800 * timeMultiplier)
#define WEATHER_VARIANCE random 0.25
#define WEATHER_THRESOLD 0.01