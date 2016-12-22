#define COMPONENT task

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

// TASK macro is dependent on file structure
// if addon's file structure changes, adjust TASK
#define TASK (((__FILE__) select [32]) select [0,(count ((__FILE__) select [32])) - 4])
#define TASK_QFUNC format ["%1_%2",QUOTE(DOUBLES(ADDON,fnc)),TASK]

#ifdef TASK_PRIMARY
	#define TASK_TYPE 1
	#define TASK_GVAR GVAR(primary)
	#define TASK_TAG '(P)'
	#define TASK_UNIT_MIN 16
	#define TASK_UNIT_MAX 40
	#define TASK_AV ((AV_MAX*0.1)*EGVAR(approval,multiplier))
	#define TASK_EXIT TASK_GVAR = []; [TASK_TYPE] call FUNC(select)
	#define TASK_PUBLISH(POS) TASK_GVAR = [TASK_QFUNC,POS]
#endif

#ifdef TASK_SECONDARY
	#define TASK_TYPE 0
	#define TASK_GVAR GVAR(secondary)
	#define TASK_TAG '(S)'
	#define TASK_UNIT_MIN 8
	#define TASK_UNIT_MAX 20
	#define TASK_AV ((AV_MAX*0.05)*EGVAR(approval,multiplier))
	#define TASK_EXIT TASK_GVAR = []; [TASK_TYPE] call FUNC(select)
	#define TASK_PUBLISH(POS) TASK_GVAR = [TASK_QFUNC,POS]
#endif

#define TASK_STRENGTH ([TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength))
#define TASK_TITLE format ["%1 %2",TASK_TAG,TASK_NAME]
#define TASK_APPROVAL(POS,AV) [POS,AV] call EFUNC(approval,addValue)
#define TASK_DIST_START 50
#define TASK_DIST_FAIL 350
#define TASK_DIST_RET 20
#define TASK_DIST_MRK 350
#define TASK_SLEEP 5

#define TASK_DEBUG(POS) \
	_mrk = createMarker [format ["%1_%2",TASK, diag_tickTime],POS]; \
	_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)]; \
	_mrk setMarkerType "mil_dot"; \
	_mrk setMarkerText TASK; \
	[_mrk] call EFUNC(main,setDebugMarker)

#define PRIM_STATEMENT [1] call FUNC(cancel)
#define PRIM_COND isServer || {serverCommandAvailable QUOTE(QUOTE(#logout))}
#define SEC_STATEMENT [0] call FUNC(cancel)
#define SEC_COND isServer || {serverCommandAvailable QUOTE(QUOTE(#logout))}

#define PREP_PRIM(TASK) PREP(TASK); GVAR(primaryList) pushBack QFUNC(TASK)
#define PREP_SEC(TASK) PREP(TASK); GVAR(secondaryList) pushBack QFUNC(TASK)
