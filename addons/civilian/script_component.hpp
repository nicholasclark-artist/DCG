#define COMPONENT civilian
#define COMPONENT_PRETTY Civilian

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define CIV_ZDIST 200
#define CIV_MOVETO_COMPLETE(AGENT) (AGENT) moveTo (getPos (AGENT))