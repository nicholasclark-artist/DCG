#define COMPONENT civilian

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define ZDIST 65
#define RANGE 1100
#define BUFFER 150
#define ITERATIONS 350
#define LOCVAR(NAME) format ["%1_%2",QUOTE(ADDON),NAME]
#define SET_LOCVAR(NAME,BOOL) missionNamespace setVariable [LOCVAR(NAME),BOOL]
#define GET_LOCVAR(NAME) missionNamespace getVariable [LOCVAR(NAME),false]