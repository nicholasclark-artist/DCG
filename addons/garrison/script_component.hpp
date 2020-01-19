#define COMPONENT garrison
#define COMPONENT_PRETTY Garrison

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define AO_COUNT_P1 10 // phase 1, adjust based on player count
#define AO_COUNT_P2 1 // phase 2
#define GAR_COUNT 1
#define OP_COUNT 2
#define TASK_COUNT 1

#define PAT_GRPSIZE 4
#define PAT_SPACING 750 // distance in meters between patrol groups
#define PAT_LIMIT 10 // max number of patrol groups per area
#define PAT_LIMIT_WATER 2 // max number of patrol groups per area

#define GAR_SCORE 10
#define OP_SCORE 5
#define TASK_SCORE 5
#define COMM_SCORE 2.5
#define ROADBLOCK_SCORE 1

#define INTEL_CLASSES [""]