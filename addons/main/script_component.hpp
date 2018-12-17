#define COMPONENT main
#define COMPONENT_PRETTY Main

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define SAVE_ID QUOTE(DOUBLES(MAIN_ADDON,saveData))
#define SAVE_ID_ENTITY(COMPONENT1) QUOTE(DOUBLES(DOUBLES(PREFIX,COMPONENT1),saveEntity))
#define SAVE_ID_ENTITY_MAIN QUOTE(DOUBLES(MAIN_ADDON,saveEntity))
#define SAVE_PVEH QUOTE(DOUBLES(MAIN_ADDON,saveDataPVEH))
#define SAVE_PVEH_DELETE QUOTE(DOUBLES(MAIN_ADDON,deleteDataPVEH))
#define SAVE_SET_VAR(VAR1) profileNamespace setVariable [SAVE_ID,VAR1]
#define SAVE_GET_VAR profileNamespace getVariable [SAVE_ID,[]]
#define SAVE_SCENARIO_ID ([QUOTE(VERSION), toUpper worldName, toUpper missionName] joinString " - ")

#define SAVE_ACTION_ID QUOTE(DOUBLES(ADDON,saveData))
#define SAVE_ACTION_NAME "Save Mission Data"
#define SAVE_ACTION_COND time > 60 && {isServer || IS_ADMIN_LOGGED}
#define SAVE_ACTION_STATEMENT \
    [] spawn { \
        closeDialog 0; \
        _ret = [ \
            parseText (format ["<t align='center'>%1</t>",format ["Are you sure you want to overwrite the saved data for %1?", SAVE_SCENARIO_ID]]), \
            TITLE, \
            "Yes", \
            "No" \
        ] call bis_fnc_GUImessage; \
        if (_ret) then { \
            publicVariableServer SAVE_PVEH; \
            ["Data saved.",true] call EFUNC(main,displayText); \
        }; \
    }

#define SAVE_ACTION_ID_DELETE QUOTE(DOUBLES(ADDON,deleteSaveData))
#define SAVE_ACTION_NAME_DELETE "Delete All Saved Mission Data"
#define SAVE_ACTION_COND_DELETE isServer || {IS_ADMIN_LOGGED}
#define SAVE_ACTION_STATEMENT_DELETE \
    [] spawn { \
    	closeDialog 0; \
    	_ret = [ \
    		parseText (format ["<t align='center'>%1</t>","Are you sure you want to permenantly delete ALL saved mission data?"]), \
    		TITLE, \
    		"Yes", \
    		"No" \
    	] call bis_fnc_GUImessage; \
    	if (_ret) then { \
    		publicVariableServer SAVE_PVEH_DELETE; \
    		["Data deleted from server.",true] call EFUNC(main,displayText); \
    	}; \
    }