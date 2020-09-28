#define COMPONENT main
#define COMPONENT_PRETTY Main

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

// debug macros
#ifdef DEBUG_ADDON
    #undef DEBUG_ADDON
#endif

#ifdef DEBUG_MODE_FULL
    #define DEBUG_ADDON 1
#else
    #define DEBUG_ADDON 0
#endif