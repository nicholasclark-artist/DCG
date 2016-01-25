#define COMPONENT approval
#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define VAL_CAR 1
#define VAL_ARMOR 2
#define VAL_AIR 3
#define VAL_SHIP 2
#define VAL_MAN 1
#define VAL_PLAYER 4
#define VAL_CIV 6
#define VAL_TASK 10
#define VAL_TOWN 10
#define VAL_CITY 20
#define VAL_CAPITAL 40
#define APPROVAL(INDEX) (random 100 <= ((call FUNC(getApproval)) select INDEX))