#define COMPONENT approval
#define COMPONENT_PRETTY Approval

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define AP_HINT_NAME "Check Approval in Region"
#define AP_HINT_STATEMENT missionNamespace setVariable [QGVAR(hintPVEH),player]; publicVariableServer QGVAR(hintPVEH);
#define AP_HINT_COND true
#define AP_HINT_KEYCODE \
    if (AP_HINT_COND) then { \
        AP_HINT_STATEMENT \
    }

#define AP_QUESTION_NAME "Question Person"
#define AP_QUESTION_STATEMENT missionNamespace setVariable [QGVAR(questionPVEH),[player,cursorTarget]]; publicVariableServer QGVAR(questionPVEH);
#define AP_QUESTION_STATEMENT_ACE missionNamespace setVariable [QGVAR(questionPVEH),[player,_target]]; publicVariableServer QGVAR(questionPVEH);
#define AP_QUESTION_COND cursorTarget isKindOf "CAManBase" && {side cursorTarget isEqualTo CIVILIAN} && {!(isPlayer cursorTarget)} && {alive cursorTarget} && {CHECK_DIST2D(player,cursorTarget,10)}
#define AP_QUESTION_COND_ACE _target isKindOf "CAManBase" && {side _target isEqualTo CIVILIAN} && {!(isPlayer _target)} && {alive _target} && {CHECK_DIST2D(player,_target,10)}
#define AP_QUESTION_KEYCODE \
    if (AP_QUESTION_COND) then { \
        AP_QUESTION_STATEMENT \
    }

#define AP_STOP_NAME "Stop Person"
#define AP_STOP_STATEMENT missionNamespace setVariable [QGVAR(stopPVEH),[player,cursorTarget]]; publicVariableServer QGVAR(stopPVEH); ["",true] call EFUNC(main,displayText);
#define AP_STOP_STATEMENT_ACE missionNamespace setVariable [QGVAR(stopPVEH),_target]; publicVariableServer QGVAR(stopPVEH); ["",true] call EFUNC(main,displayText);
#define AP_STOP_COND cursorTarget isKindOf "CAManBase" && {side cursorTarget isEqualTo CIVILIAN} && {!(isPlayer cursorTarget)} && {alive cursorTarget} && {CHECK_DIST2D(player,cursorTarget,10)}
#define AP_STOP_COND_ACE _target isKindOf "CAManBase" && {side _target isEqualTo CIVILIAN} && {!(isPlayer _target)} && {alive _target} && {CHECK_DIST2D(player,_target,10)}
#define AP_STOP_KEYCODE \
    if (AP_STOP_COND) then { \
        AP_STOP_STATEMENT \
    }
