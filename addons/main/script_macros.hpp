#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) FUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define PREP_MODULE(folder) [] call compile preprocessFileLineNumbers QPATHTOF(folder\__PREP__.sqf)

#define HEADLESSCLIENT GVARMAIN(HC)
#define ACTIONPATH [QUOTE(DOUBLES(ACE,SelfActions)),QGVARMAIN(actions),QUOTE(ADDON)]
#define SETTINGS_INIT publicVariable QFUNC(initSettings); remoteExecCall [QFUNC(initSettings), -2, true]; call FUNC(initSettings)
// #define SETTINGS_OVERWRITE(SETTING,VALUE) [{MAIN_ADDON && {CHECK_POSTBRIEFING}},{missionNamespace setVariable [SETTING,_this]},VALUE] remoteExecCall [QUOTE(CBA_fnc_waitUntilAndExecute),-2,true]

#define ISDRIVER QEGVAR(main,isDriver)
#define ISONPATROL QEGVAR(main,isOnPatrol)

#define CHECK_DEBUG (EGVAR(main,debug) isEqualTo 1)
#define CHECK_MARKER(MARKER) (getMarkerColor MARKER != '')
#define CHECK_ADDON_1(PATCH) (isClass (configfile >> 'CfgPatches' >> PATCH))
#define CHECK_ADDON_2(VAR) (CHECK_ADDON_1(QGVARMAIN(VAR)) && {EGVAR(VAR,enable)})
#define CHECK_DIST(POS1,POS2,DIST) (POS1) distance (POS2) <= (DIST)
#define CHECK_DIST2D(POS1,POS2,DIST) (POS1) distance2D (POS2) <= (DIST)
#define CHECK_VECTORDIST(POS1,POS2,DIST) (POS1) vectorDistance (POS2) <= (DIST)
#define CHECK_POSTBRIEFING (getClientStateNumber > 9)
#define CHECK_PREINIT if (!isServer) exitWith {}
#define CHECK_POSTINIT if (!(EGVAR(main,enable)) || {!(GVAR(enable))} || {!isServer} || {!isMultiplayer}) exitWith {}

#define COMPARE_STR(STR1,STR2) ((STR1) == (STR2))
#define COMPARE_STR_CASE(STR1,STR2) ((STR1) isEqualTo (STR2))

// save macros 
#define SAVE_ID QUOTE(DOUBLES(MAIN_ADDON,saveData))
#define SAVE_ID_ENTITY(COMPONENT1) QUOTE(DOUBLES(GVARMAIN(COMPONENT1),saveEntity))
#define SAVE_ID_ENTITY_MAIN QUOTE(DOUBLES(MAIN_ADDON,saveEntity))
#define SAVE_PVEH QUOTE(DOUBLES(MAIN_ADDON,saveDataPVEH))
#define SAVE_PVEH_DELETE QUOTE(DOUBLES(MAIN_ADDON,deleteDataPVEH))
#define SAVE_SET_VAR(VAR1) profileNamespace setVariable [SAVE_ID,VAR1]
#define SAVE_GET_VAR profileNamespace getVariable [SAVE_ID,[]]
#define SAVE_SCENARIO_ID ([QUOTE(VERSION), toUpper worldName, toUpper missionName] joinString " - ")

// fob macros
#define COST_MAN 1.5
#define COST_CAR 3
#define COST_TANK 6
#define COST_AIR 8
#define COST_SHIP 3
#define COST_AMMO 0.1
#define COST_STRUCT 2
#define COST_ITEM 0.1
#define COST_FORT 0.2
#define COST_SIGN 0.1

// approval macros
#define PVEH_AVADD QEGVAR(approval,pveh_add)
#define AV_LOCATION_ID(LOCATION) ([QUOTE(PREFIX),"approval",LOCATION] joinString "_")
#define AV_MIN 0
#define AV_MAX 100
#define AV_DEFAULT AV_MAX*0.1
#define AV_CAR ((AV_MAX*0.005)*EGVAR(approval,multiplier))
#define AV_TANK ((AV_MAX*0.0075)*EGVAR(approval,multiplier))
#define AV_AIR ((AV_MAX*0.01)*EGVAR(approval,multiplier))
#define AV_SHIP ((AV_MAX*0.005)*EGVAR(approval,multiplier))
#define AV_MAN ((AV_MAX*0.001)*EGVAR(approval,multiplier))
#define AV_CIV ((AV_MAX*0.01)*EGVAR(approval,multiplier))
#define AV_FOB ((AV_MAX*0.0025)*EGVAR(approval,multiplier))
#define AV_VILLAGE ((AV_MAX*0.05)*EGVAR(approval,multiplier))
#define AV_CITY ((AV_MAX*0.1)*EGVAR(approval,multiplier))
#define AV_CAPITAL ((AV_MAX*0.15)*EGVAR(approval,multiplier))
#define AV_CONVERT1(POS) (linearConversion [AV_MIN, AV_MAX, [POS] call EFUNC(approval,getValue), 0, 1, true])
#define AV_CONVERT2(POS) (1 - ((1 - AV_CONVERT1(POS)) * 0.5))
