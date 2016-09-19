#define COMPONENT fob
//#define DISABLE_COMPILE_CACHE
#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define PVEH_DEPLOY QGVAR(pveh_deploy)
#define PVEH_DELETE QGVAR(pveh_delete)
#define PVEH_REQUEST QGVAR(pveh_request)
#define PVEH_REASSIGN QGVAR(pveh_reassign)
#define FOB_MED ["Land_Medevac_house_V1_F", "Land_Medevac_HQ_V1_F","B_Slingload_01_Medevac_F"]
#define RECON GVAR(reconUAV)

#define SET_PATROL \
	{ \
		if (_x isKindOf 'Man' && {_x isEqualTo leader group _x} && {!(_x getVariable ['dcg_isOnPatrol',-1] isEqualTo 1)}) then { \
			[units group _x,GVAR(range),false] call EFUNC(main,setPatrol); \
			_x addEventHandler ['Local',{ \
				if (_this select 1) then { \
					_x setVariable ['dcg_isOnPatrol',0]; \
					[units group (_this select 0),GVAR(range),false] call EFUNC(main,setPatrol); \
				}; \
			}]; \
		}; \
	} forEach (curatorEditableObjects GVAR(curator));

#define DEPLOY_ID QUOTE(DOUBLES(ADDON,deploy))
#define DEPLOY_NAME "Deploy FOB"
#define DEPLOY_STATEMENT call FUNC(deploy)
#define DEPLOY_COND call FUNC(canDeploy)
#define DEPLOY_KEYCODE \
	if (DEPLOY_COND) then { \
		DEPLOY_STATEMENT \
	}

#define REQUEST_ID QUOTE(DOUBLES(ADDON,request))
#define REQUEST_NAME "Request Control of FOB"
#define REQUEST_STATEMENT call FUNC(request)
#define REQUEST_COND !(GVAR(location) isEqualTo locationNull) && {!(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))}
#define REQUEST_KEYCODE \
	if (REQUEST_COND) then { \
		REQUEST_STATEMENT \
	}

#define DISMANTLE_ID QUOTE(DOUBLES(ADDON,dismantle))
#define DISMANTLE_NAME "Dismantle FOB"
#define DISMANTLE_STATEMENT call FUNC(delete)
#define DISMANTLE_COND player isEqualTo (getAssignedCuratorUnit GVAR(curator)) && {cameraOn isEqualTo player}
#define DISMANTLE_KEYCODE \
	if (DISMANTLE_COND) then { \
		DISMANTLE_STATEMENT \
	}

#define PATROL_ID QUOTE(DOUBLES(ADDON,patrol))
#define PATROL_NAME "Set FOB Groups on Patrol"
#define PATROL_STATEMENT SET_PATROL
#define PATROL_COND player isEqualTo (getAssignedCuratorUnit GVAR(curator))
#define PATROL_KEYCODE \
	if (PATROL_COND) then { \
		PATROL_STATEMENT \
	}

#define RECON_ID QUOTE(DOUBLES(ADDON,recon))
#define RECON_NAME "FOB Aerial Recon"
#define RECON_STATEMENT \
	if (((UAVControl RECON) select 0) isEqualTo player) then { \
		objNull remoteControl gunner RECON; \
		player switchCamera "internal"; \
	} else { \
		player remoteControl gunner RECON; \
		RECON switchCamera "internal"; \
	}
#define RECON_COND player isEqualTo (getAssignedCuratorUnit GVAR(curator)) && {!isNull RECON}
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
#define BUILD_COND player isEqualTo (getAssignedCuratorUnit GVAR(curator)) && {isNull (objectParent player)} && {cameraOn isEqualTo player}
#define BUILD_KEYCODE \
	if (BUILD_COND) then { \
		BUILD_STATEMENT \
	}

