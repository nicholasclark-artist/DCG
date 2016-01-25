#define COMPONENT fob
#include "\d\dcg\addons\main\script_mod.hpp"
#include "\d\dcg\addons\main\script_macros.hpp"

#define ACTIONPATH ["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]
#define PVEH_DEPLOY QUOTE(DOUBLES(ADDON,pveh_deploy))
#define PVEH_REQUEST QUOTE(DOUBLES(ADDON,pveh_request))
#define PVEH_REASSIGN QUOTE(DOUBLES(ADDON,pveh_reassign))
#define ARRAY_HQ ["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"]
#define ARRAY_MED ["Land_Medevac_house_V1_F", "Land_Medevac_HQ_V1_F"]
#define COST_MAN 1.5
#define COST_CAR 2
#define COST_TANK 4
#define COST_AIR 8
#define COST_SHIP 2
#define COST_AMMO 4
#define COST_STRUCT 2
#define COST_ITEM 0.5
#define COST_FORT 0.25
#define COST_SIGN 0.5