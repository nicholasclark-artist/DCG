#define COMPONENT weather
#define COMPONENT_PRETTY Weather

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define WEATHER_DELAY_OVERCAST (1800 * timeMultiplier)
#define WEATHER_DELAY_RAIN (((random (300 - 60)) + 60) * timeMultiplier)
#define WEATHER_DELAY_FOG (1800 * timeMultiplier)

#define WEATHER_DEVIATION 0.002

#define WEATHER_OVERCAST_VARIANCE (0.15 * GVAR(variance))
#define WEATHER_RAIN_VARIANCE (0.2 * GVAR(variance))
#define WEATHER_FOG_VARIANCE (0.2 * GVAR(variance))
