#define COMPONENT fob

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define COST_MULTIPIER 0.5
#define FOB_RECON GVAR(uav)
#define FOB_DEPLOYED !(GVAR(location) isEqualTo locationNull)
#define FOB_POSITION (getPos GVAR(location))
#define FOB_MED ["Land_Medevac_house_V1_F", "Land_Medevac_HQ_V1_F","B_Slingload_01_Medevac_F"]
#define FOB_CREATE_ANIM 'AinvPknlMstpSnonWnonDnon_medic4'

#define PVEH_CREATE QGVAR(pveh_create)
#define PVEH_DELETE QGVAR(pveh_delete)
#define PVEH_TRANSFER QGVAR(pveh_transfer)
#define PVEH_ASSIGN QGVAR(PVEH_ASSIGN)

#define CREATE_ID QUOTE(DOUBLES(ADDON,create))
#define CREATE_NAME "Deploy FOB"
#define CREATE_STATEMENT \
    [player,FOB_CREATE_ANIM] call EFUNC(main,setAnim); \
    [{ \
        _format = format ["Forward Operating Base Deployed \n \nPress [%1] to start building",call FUNC(getKeybind)]; \
        [_format,true] call EFUNC(main,displayText); \
    	missionNamespace setVariable [PVEH_CREATE,player]; \
    	publicVariableServer PVEH_CREATE; \
    }, [], 9] call CBA_fnc_waitAndExecute

#define CREATE_COND !(FOB_DEPLOYED) && {isNull (objectParent player)} && {((getPosATL player) select 2) < 10} && {!(COMPARE_STR(animationState player,FOB_CREATE_ANIM))} && {[player] call FUNC(isAllowedOwner)} && {!((getpos player isFlatEmpty  [6, -1, -1, -1, 0, false, player]) isEqualTo [])}
#define CREATE_KEYCODE \
	if (CREATE_COND) then { \
		CREATE_STATEMENT \
	}

#define TRANSFER_ID QUOTE(DOUBLES(ADDON,transfer))
#define TRANSFER_NAME "Transfer FOB Control"
#define TRANSFER_STATEMENT \
    missionNamespace setVariable [PVEH_TRANSFER,[player,cursorObject]]; \
    publicVariableServer PVEH_TRANSFER; \
    [format ["FOB control transferred to %1", name cursorObject],true] call EFUNC(main,displayText)
#define TRANSFER_STATEMENT_ACE \
    missionNamespace setVariable [PVEH_TRANSFER,[player,_target]]; \
    publicVariableServer PVEH_TRANSFER; \
    [format ["FOB control transferred to %1", name _target],true] call EFUNC(main,displayText)
#define TRANSFER_COND FOB_DEPLOYED && {player isEqualTo getAssignedCuratorUnit GVAR(curator)} && {isPlayer cursorObject} && {cursorObject isKindOf 'CAManBase'} && {[cursorObject] call FUNC(isAllowedOwner)}
#define TRANSFER_COND_ACE FOB_DEPLOYED && {player isEqualTo getAssignedCuratorUnit GVAR(curator)} && {isPlayer _target} && {_target isKindOf 'CAManBase'} && {[_target] call FUNC(isAllowedOwner)}
#define TRANSFER_KEYCODE \
    if (CHECK_ADDON_1('ace_interact_menu')) then { \
        if (TRANSFER_COND_ACE) then { \
            TRANSFER_STATEMENT_ACE \
        } \
    } else { \
        if (TRANSFER_COND) then { \
    		TRANSFER_STATEMENT \
    	} \
    }

#define CONTROL_ID QUOTE(DOUBLES(ADDON,control))
#define CONTROL_NAME "Assume FOB Control"
#define CONTROL_STATEMENT \
    missionNamespace setVariable [PVEH_ASSIGN,player]; \
    publicVariableServer PVEH_ASSIGN; \
    call FUNC(curatorEH); \
    ["You've taken control of the Forward Operating Base",true] call EFUNC(main,displayText)
#define CONTROL_COND FOB_DEPLOYED && {isNull (getAssignedCuratorUnit GVAR(curator))} && {[player] call FUNC(isAllowedOwner)}
#define CONTROL_KEYCODE \
	if (CONTROL_COND) then { \
		CONTROL_STATEMENT \
	}

#define DELETE_ID QUOTE(DOUBLES(ADDON,delete))
#define DELETE_NAME "Dismantle FOB"
#define DELETE_STATEMENT \
    [ \
        "Are you sure you want to dismantle the Forward Operating Base?", \
        TITLE, \
        "Forward Operating Base dismantled.", \
        {missionNamespace setVariable [(_this select 0),true]; publicVariableServer (_this select 0);}, \
        [PVEH_DELETE] \
    ] call EFUNC(main,displayGUIMessage)
#define DELETE_COND player isEqualTo getAssignedCuratorUnit GVAR(curator) && {cameraOn isEqualTo player} && {!(visibleMap)}
#define DELETE_KEYCODE \
	if (DELETE_COND) then { \
		DELETE_STATEMENT \
	}

#define RECON_ID QUOTE(DOUBLES(ADDON,recon))
#define RECON_NAME "FOB Aerial Recon"
#define RECON_STATEMENT \
	if (((UAVControl FOB_RECON) select 0) isEqualTo player) then { \
		objNull remoteControl gunner FOB_RECON; \
		player switchCamera "internal"; \
	} else { \
		player remoteControl gunner FOB_RECON; \
		FOB_RECON switchCamera "internal"; \
	}
#define RECON_COND player isEqualTo getAssignedCuratorUnit GVAR(curator) && {!isNull FOB_RECON} && {!(visibleMap)}
#define RECON_KEYCODE \
	if (RECON_COND) then { \
		RECON_STATEMENT \
	}

#define BUILD_ID QUOTE(DOUBLES(ADDON,build))
#define BUILD_NAME "Build FOB"
#define BUILD_STATEMENT \
	if (isNull (findDisplay 312)) then { \
		openCuratorInterface; \
	} else { \
		findDisplay 312 closeDisplay 2; \
	}
#define BUILD_COND player isEqualTo getAssignedCuratorUnit GVAR(curator) && {isNull (objectParent player)} && {cameraOn isEqualTo player} && {!(visibleMap)}
#define BUILD_KEYCODE \
	if (BUILD_COND) then { \
		BUILD_STATEMENT \
	}
