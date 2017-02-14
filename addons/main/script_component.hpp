#define COMPONENT main

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define DATA_SAVEVAR QUOTE(DOUBLES(MAIN_ADDON,saveData))
#define DATA_SAVEPVEH QUOTE(DOUBLES(MAIN_ADDON,saveDataPVEH))
#define DATA_DELETEPVEH QUOTE(DOUBLES(MAIN_ADDON,deleteDataPVEH))
#define DATA_OBJVAR QUOTE(DOUBLES(MAIN_ADDON,saveObject))
#define DATA_SETVAR(VAR1) profileNamespace setVariable [DATA_SAVEVAR,VAR1]
#define DATA_GETVAR profileNamespace getVariable [DATA_SAVEVAR,[]]
#define DATA_MISSION_ID ([QUOTE(VERSION), toUpper worldName, toUpper missionName] joinString " - ")

#define SAVEDATA_ID QUOTE(DOUBLES(ADDON,saveData))
#define SAVEDATA_NAME "Save Mission Data"
#define SAVEDATA_STATEMENT \
    [] spawn { \
        closeDialog 0; \
        _ret = [ \
            parseText (format ["<t align='center'>%1</t>",format ["Are you sure you want to overwrite the saved data for %1?", DATA_MISSION_ID]]), \
            TITLE, \
            "Yes", \
            "No" \
        ] call bis_fnc_GUImessage; \
        if (_ret) then { \
            publicVariableServer DATA_SAVEPVEH; \
            ["Data saved.",true] call EFUNC(main,displayText); \
        }; \
    }
#define SAVEDATA_COND time > 60 && {isServer || serverCommandAvailable QUOTE(QUOTE(#logout))}

#define DELETEDATA_ID QUOTE(DOUBLES(ADDON,deleteSaveData))
#define DELETEDATA_NAME "Delete All Saved Mission Data"
#define DELETEDATA_STATEMENT \
    [] spawn { \
    	closeDialog 0; \
    	_ret = [ \
    		parseText (format ["<t align='center'>%1</t>","Are you sure you want to permenantly delete ALL saved mission data?"]), \
    		TITLE, \
    		"Yes", \
    		"No" \
    	] call bis_fnc_GUImessage; \
    	if (_ret) then { \
    		publicVariableServer DATA_DELETEPVEH; \
    		["Data deleted from server.",true] call EFUNC(main,displayText); \
    	}; \
    }
#define DELETEDATA_COND isServer || {serverCommandAvailable QUOTE(QUOTE(#logout))}
