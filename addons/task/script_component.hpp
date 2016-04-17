#define COMPONENT task
#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define ENDP GVAR(primary) = []; publicVariable QGVAR(primary); [1] spawn FUNC(select);
#define ENDS GVAR(secondary) = []; publicVariable QGVAR(secondary); [0] spawn FUNC(select);
#define PMIN 16
#define PMAX 30
#define SMIN 8
#define SMAX 16
#define START_DIST 50
#define FAIL_DIST 500
#define RETURN_DIST 20
#define MRK_DIST 350
#define HANDLER_SLEEP 10