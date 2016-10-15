#define COMPONENT civilian

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define ZDIST 65
#define RANGE 1100
#define BUFFER 150
#define ITERATIONS 350
#define LOCATION_ID(NAME) ([QUOTE(ADDON),NAME] joinString "_")