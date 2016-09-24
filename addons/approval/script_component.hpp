#define COMPONENT approval
//#define DISABLE_COMPILE_CACHE
#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define PVEH_HINT QGVAR(pveh_hint)
#define HINT_CODE QUOTE(SETMVAR(PVEH_HINT,player); publicVariableServer QUOTE(PVEH_HINT))
#define HINT_KEYID QUOTE(DOUBLES(ADDON,hint))
#define HINT_NAME "Check Approval in Region"

#define PVEH_QUESTION QGVAR(pveh_question)
#define QUESTION_CODE QUOTE(SETMVAR(PVEH_QUESTION,player); publicVariableServer QUOTE(PVEH_QUESTION))
#define QUESTION_KEYID QUOTE(DOUBLES(ADDON,question))
#define QUESTION_NAME "Question Nearby Person"