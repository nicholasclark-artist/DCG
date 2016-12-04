#define COMPONENT transport

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define PVEH_REQUEST QGVAR(request)
#define STR_EXFIL "Open your map and select a LZ for extraction."
#define STR_INFIL "Select a LZ for insertion."
#define STR_CLOSE "Insertion LZ is too close to extraction LZ."
#define STR_NOTLAND "LZ must be on land."
#define STR_BADTERRAIN "Unsuitable terrain. Select another LZ."
#define STR_CANCEL "Transport request canceled."
#define MRK_INFIL(VAR) ([VAR,"infil"] joinString "_")
#define MRK_EXFIL(VAR) ([VAR,"exfil"] joinString "_")
#define EH_INFIL ([QUOTE(ADDON),"infilLZ"] joinString "_")
#define EH_EXFIL ([QUOTE(ADDON),"exfilLZ"] joinString "_")
#define TR_CHECKDIST 15
