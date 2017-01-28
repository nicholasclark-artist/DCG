#define COMPONENT approval

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
#define QUESTION_STATEMENT missionNamespace setVariable [PVEH_QUESTION,[player,cursorObject]]; publicVariableServer PVEH_QUESTION;
#define QUESTION_STATEMENT_ACE missionNamespace setVariable [PVEH_QUESTION,[player,_target]]; publicVariableServer PVEH_QUESTION;
#define QUESTION_COND cursorObject isKindOf 'CAManBase' && {!(side cursorObject isEqualTo EGVAR(main,enemySide))} && {!(isPlayer cursorObject)} && {alive cursorObject}
#define QUESTION_COND_ACE _target isKindOf 'CAManBase' && {!(side _target isEqualTo EGVAR(main,enemySide))} && {!(isPlayer _target)} && {alive _target}
#define QUESTION_KEYCODE \
    if (CHECK_ADDON_1('ace_interact_menu')) then { \
        if (QUESTION_COND_ACE) then { \
            QUESTION_STATEMENT_ACE \
        } \
    } else { \
        if (QUESTION_COND) then { \
    		QUESTION_STATEMENT \
    	} \
    }
