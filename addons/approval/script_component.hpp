#define COMPONENT approval
#define COMPONENT_PRETTY Approval

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define PVEH_HINT QGVAR(pveh_hint)
#define HINT_ID QUOTE(DOUBLES(ADDON,hint))
#define HINT_NAME "Check Approval in Region"
#define HINT_STATEMENT missionNamespace setVariable [PVEH_HINT,player]; publicVariableServer PVEH_HINT;
#define HINT_COND true
#define HINT_KEYCODE \
    if (HINT_COND) then { \
        HINT_STATEMENT \
    }

#define PVEH_QUESTION QGVAR(pveh_question)
#define QUESTION_ID QUOTE(DOUBLES(ADDON,question))
#define QUESTION_NAME "Question Person"
#define QUESTION_STATEMENT missionNamespace setVariable [PVEH_QUESTION,[player,cursorTarget]]; publicVariableServer PVEH_QUESTION;
#define QUESTION_STATEMENT_ACE missionNamespace setVariable [PVEH_QUESTION,[player,_target]]; publicVariableServer PVEH_QUESTION;
#define QUESTION_COND cursorTarget isKindOf 'CAManBase' && {side cursorTarget isEqualTo CIVILIAN} && {!(isPlayer cursorTarget)} && {alive cursorTarget} && {CHECK_DIST2D(player,cursorTarget,10)}
#define QUESTION_COND_ACE _target isKindOf 'CAManBase' && {side _target isEqualTo CIVILIAN} && {!(isPlayer _target)} && {alive _target} && {CHECK_DIST2D(player,_target,10)}
#define QUESTION_KEYCODE \
    if (QUESTION_COND) then { \
        QUESTION_STATEMENT \
    }

#define PVEH_HALT QGVAR(pveh_halt)
#define HALT_ID QUOTE(DOUBLES(ADDON,halt))
#define HALT_NAME "Stop!"
#define HALT_STATEMENT missionNamespace setVariable [PVEH_HALT,cursorTarget]; publicVariableServer PVEH_HALT; ["",true] call EFUNC(main,displayText);
#define HALT_STATEMENT_ACE missionNamespace setVariable [PVEH_HALT,_target]; publicVariableServer PVEH_HALT; ["",true] call EFUNC(main,displayText);
#define HALT_COND cursorTarget isKindOf 'CAManBase' && {side cursorTarget isEqualTo CIVILIAN} && {!(isPlayer cursorTarget)} && {alive cursorTarget} && {CHECK_DIST2D(player,cursorTarget,10)}
#define HALT_COND_ACE _target isKindOf 'CAManBase' && {side _target isEqualTo CIVILIAN} && {!(isPlayer _target)} && {alive _target} && {CHECK_DIST2D(player,_target,10)}
#define HALT_KEYCODE \
    if (HALT_COND) then { \
        HALT_STATEMENT \
    }
