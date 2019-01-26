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

// save macros 
#define SAVE_SETVAR(VAR1) profileNamespace setVariable [QGVAR(saveData),VAR1]
#define SAVE_GETVAR profileNamespace getVariable [QGVAR(saveData),[]]
#define SAVE_SCENARIO_ID ([QUOTE(VERSION), toUpper worldName, toUpper missionName] joinString " - ")

#define SAVE_ACTION_NAME "Save Mission Data"
#define SAVE_ACTION_COND CBA_missionTime > 60 && {isServer || IS_ADMIN_LOGGED}
#define SAVE_ACTION_STATEMENT \
    [ \
        format ["Are you sure you want to overwrite the saved data for %1?", SAVE_SCENARIO_ID], \
        TITLE, \
        "Data saved to server profile.", \
        {[QGVAR(saveData),[]] call CBA_fnc_serverEvent} \
    ] spawn FUNC(displayGUIMessage)

#define SAVE_ACTION_NAME_DELETE "Delete All Saved Mission Data"
#define SAVE_ACTION_COND_DELETE isServer || {IS_ADMIN_LOGGED}
#define SAVE_ACTION_STATEMENT_DELETE \
    [ \
        "Are you sure you want to permenantly delete ALL saved mission data?", \
        TITLE, \
        "Data deleted from server profile.", \
        {[QGVAR(deleteData),[]] call CBA_fnc_serverEvent} \
    ] spawn FUNC(displayGUIMessage)