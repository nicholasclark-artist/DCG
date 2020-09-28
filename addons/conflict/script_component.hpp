#define COMPONENT conflict
#define COMPONENT_PRETTY Conflict

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define AO_POLY_ID(id) ([QUOTE(PREFIX),"polygonDraw",id] joinString "_")

#define AO_COUNT_P1 2 // phase 1
#define AO_COUNT_P2 1 // phase 2
#define OP_COUNT 2

#define AO_INF_GRPSIZE 4 // number of units in group
#define AO_INF_GRPSPACING 750 // distance in meters between patrol groups
#define AO_INF_GRPLIMIT 8 // max number of patrol groups per area
#define AO_SHIP_GRPLIMIT 2 // max number of patrol groups per area
#define AO_SHIP_CARGO 1 // number of units to cargo

#define DYNPAT_RANGE 5000 // max distance from AO to consider dynamic patrols
#define DYNPAT_SPAWNRANGE 500 // max distance from players to spawn dynamic patrol
#define DYNPAT_GRPLIMIT 4 // max number of dynamic patrol groups

#define INTEL_ITEMS ["intel_file1_f","intel_file2_f","land_document_01_f","land_laptop_unfolded_f","land_laptop_03_black_f","land_laptop_03_sand_f","land_laptop_03_olive_f"]
#define INTEL_SURFACES ["land_campingtable_f","land_campingtable_small_f","land_campingtable_small_white_f","land_campingtable_white_f","land_tableplastic_01_f","land_woodentable_large_f","land_woodentable_small_f","officetable_01_new_f","officetable_01_old_f","land_portabledesk_01_olive_f"]