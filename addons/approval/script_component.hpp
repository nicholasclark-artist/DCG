#define COMPONENT approval
#define COMPONENT_PRETTY Approval

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define AP_HINT_NAME "Region Data"
#define AP_HINT_STATEMENT [QGVAR(hint), [player]] call CBA_fnc_serverEvent
#define AP_HINT_COND true
#define AP_HINT_KEYCODE \
    if (AP_HINT_COND) then { \
        AP_HINT_STATEMENT \
    }

#define AP_QUESTION_NAME "Question Person"
#define AP_QUESTION_STATEMENT [QGVAR(question), [player,cursorTarget]] call CBA_fnc_serverEvent
#define AP_QUESTION_STATEMENT_ACE [QGVAR(question), [player,_target]] call CBA_fnc_serverEvent
#define AP_QUESTION_COND cursorTarget isKindOf "CAManBase" && {side cursorTarget isEqualTo CIVILIAN} && {!(isPlayer cursorTarget)} && {alive cursorTarget} && {CHECK_DIST2D(player,cursorTarget,6)} && {cursorTarget getVariable [QGVAR(isStopped),false]}
#define AP_QUESTION_COND_ACE _target isKindOf "CAManBase" && {side _target isEqualTo CIVILIAN} && {!(isPlayer _target)} && {alive _target} && {CHECK_DIST2D(player,_target,6)} && {_target getVariable [QGVAR(isStopped),false]}
#define AP_QUESTION_KEYCODE \
    if (AP_QUESTION_COND) then { \
        AP_QUESTION_STATEMENT \
    }

#define AP_STOP_NAME "Stop Person"
#define AP_STOP_STATEMENT [QGVAR(stop), [player,cursorTarget], cursorTarget] call CBA_fnc_targetEvent; ["",true] call EFUNC(main,displayText)
#define AP_STOP_STATEMENT_ACE [QGVAR(stop), [player,_target], _target] call CBA_fnc_targetEvent; ["",true] call EFUNC(main,displayText)
#define AP_STOP_COND cursorTarget isKindOf "CAManBase" && {side cursorTarget isEqualTo CIVILIAN} && {!(isPlayer cursorTarget)} && {alive cursorTarget} && {CHECK_DIST2D(player,cursorTarget,10)} && {!(cursorTarget getVariable [QGVAR(isStopped),false])}
#define AP_STOP_COND_ACE _target isKindOf "CAManBase" && {side _target isEqualTo CIVILIAN} && {!(isPlayer _target)} && {alive _target} && {CHECK_DIST2D(player,_target,10)} && {!(_target getVariable [QGVAR(isStopped),false])}
#define AP_STOP_KEYCODE \
    if (AP_STOP_COND) then { \
        AP_STOP_STATEMENT \
    }
