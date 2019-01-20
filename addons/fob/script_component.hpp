#define COMPONENT fob
#define COMPONENT_PRETTY FOB

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define FOB_COST_MULTIPIER 0.5
#define FOB_DEPLOYED !(GVAR(location) isEqualTo locationNull)
#define FOB_POSITION (getPos GVAR(location))
#define FOB_MED ["Land_Medevac_house_V1_F", "Land_Medevac_HQ_V1_F","B_Slingload_01_Medevac_F"]

#define FOB_CREATE_NAME "Deploy FOB"
#define FOB_CREATE_ANIM 'AinvPknlMstpSnonWnonDnon_medic4'
#define FOB_CREATE_STATEMENT \
    [player,FOB_CREATE_ANIM] call EFUNC(main,setAnim); \
    [{ \
        _format = format ["Forward Operating Base Deployed \n \nPress [%1] to start building",call FUNC(getKeybind)]; \
        [_format,true] call EFUNC(main,displayText); \
        [QGVAR(create),[player]] call CBA_fnc_serverEvent; \
    }, [], 9] call CBA_fnc_waitAndExecute

#define FOB_CREATE_COND !(FOB_DEPLOYED) && {isNull getAssignedCuratorUnit GVAR(curator)} && {isNull (objectParent player)} && {((getPosATL player) select 2) < 10} && {!(COMPARE_STR(animationState player,FOB_CREATE_ANIM))} && {[player] call FUNC(isAllowedOwner)} && {!((getpos player isFlatEmpty  [6, -1, -1, -1, 0, false, player]) isEqualTo [])}
#define FOB_CREATE_KEYCODE \
    if (FOB_CREATE_COND) then { \
        FOB_CREATE_STATEMENT \
    }

#define FOB_TRANSFER_NAME "Transfer FOB Control"
#define FOB_TRANSFER_STATEMENT \
    [QGVAR(transfer),[player,cursorTarget]] call CBA_fnc_serverEvent; \
    [format ["FOB control transferred to %1", name cursorTarget],true] call EFUNC(main,displayText)
#define FOB_TRANSFER_STATEMENT_ACE \
    [QGVAR(transfer),[player,_target]] call CBA_fnc_serverEvent; \
    [format ["FOB control transferred to %1", name _target],true] call EFUNC(main,displayText)
#define FOB_TRANSFER_COND FOB_DEPLOYED && {player isEqualTo getAssignedCuratorUnit GVAR(curator)} && {isPlayer cursorTarget} && {cursorTarget isKindOf 'CAManBase'} && {[cursorTarget] call FUNC(isAllowedOwner)}
#define FOB_TRANSFER_COND_ACE FOB_DEPLOYED && {player isEqualTo getAssignedCuratorUnit GVAR(curator)} && {isPlayer _target} && {_target isKindOf 'CAManBase'} && {[_target] call FUNC(isAllowedOwner)}
#define FOB_TRANSFER_KEYCODE \
    if (FOB_TRANSFER_COND) then { \
        FOB_TRANSFER_STATEMENT \
    }

#define FOB_CONTROL_NAME "Assume FOB Control"
#define FOB_CONTROL_STATEMENT \
    [QGVAR(assign), [GVAR(curator), player]] call CBA_fnc_serverEvent; \
    [ \
        {getAssignedCuratorUnit GVAR(curator) isEqualTo player}, \
        { \
            call FUNC(curatorEH); \
            ["You've taken control of the Forward Operating Base",true] call EFUNC(main,displayText) \
        }, \
        [] \
    ] call CBA_fnc_waitUntilAndExecute
#define FOB_CONTROL_COND FOB_DEPLOYED && {isNull (getAssignedCuratorUnit GVAR(curator))} && {[player] call FUNC(isAllowedOwner)}
#define FOB_CONTROL_KEYCODE \
    if (FOB_CONTROL_COND) then { \
        FOB_CONTROL_STATEMENT \
    }

#define FOB_DELETE_NAME "Dismantle FOB"
#define FOB_DELETE_STATEMENT \
    [ \
        "Are you sure you want to dismantle the Forward Operating Base?", \
        TITLE, \
        "Forward Operating Base dismantled.", \
        {[_this select 0, []] call CBA_fnc_serverEvent}, \
        [QGVAR(delete)] \
    ] spawn EFUNC(main,displayGUIMessage)
#define FOB_DELETE_COND player isEqualTo getAssignedCuratorUnit GVAR(curator) && {cameraOn isEqualTo player} && {!(visibleMap)}
#define FOB_DELETE_KEYCODE \
    if (FOB_DELETE_COND) then { \
        FOB_DELETE_STATEMENT \
    }

#define FOB_RECON_NAME "FOB Aerial Recon"
#define FOB_RECON_STATEMENT \
    if (((UAVControl GVAR(uav)) select 0) isEqualTo player) then { \
        objNull remoteControl gunner GVAR(uav); \
        player switchCamera "internal"; \
    } else { \
        player remoteControl gunner GVAR(uav); \
        GVAR(uav) switchCamera "internal"; \
    }
#define FOB_RECON_COND player isEqualTo getAssignedCuratorUnit GVAR(curator) && {!isNull GVAR(uav)} && {!(visibleMap)}
#define FOB_RECON_KEYCODE \
    if (FOB_RECON_COND) then { \
        FOB_RECON_STATEMENT \
    }

#define FOB_BUILD_NAME "Build FOB"
#define FOB_BUILD_STATEMENT \
    if (isNull (findDisplay 312)) then { \
        openCuratorInterface; \
    } else { \
        findDisplay 312 closeDisplay 2; \
    }
#define FOB_BUILD_COND player isEqualTo getAssignedCuratorUnit GVAR(curator) && {isNull (objectParent player)} && {cameraOn isEqualTo player} && {!(visibleMap)}
#define FOB_BUILD_KEYCODE \
    if (FOB_BUILD_COND) then { \
        FOB_BUILD_STATEMENT \
    }
