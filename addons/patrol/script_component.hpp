#define COMPONENT patrol
#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define UNITCOUNT(MIN,MAX) floor (random ((MAX - MIN) + 1)) + MIN
#define LAYER1_COUNT ceil(EGVAR(main,range)*0.0013)
#define LAYER1_RANGE ceil(EGVAR(main,range)*0.1) max 500
#define LAYER2_MINRANGE 300
#define LAYER2_RANGE 1000