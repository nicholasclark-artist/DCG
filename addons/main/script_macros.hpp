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

#define CHECK_DEBUG (EGVAR(main,debug) isEqualTo 1)
#define CHECK_MARKER(MARKER) (getMarkerColor MARKER != '')
#define CHECK_ADDON_1(PATCH) (isClass (configfile >> 'CfgPatches' >> PATCH))
#define CHECK_ADDON_2(VAR) (CHECK_ADDON_1(QGVARMAIN(VAR)) && {EGVAR(VAR,enable)})
#define CHECK_DIST(POS1,POS2,DIST) (POS1) distance (POS2) <= (DIST)
#define CHECK_DIST2D(POS1,POS2,DIST) (POS1) distance2D (POS2) <= (DIST)
#define CHECK_VECTORDIST(POS1,POS2,DIST) (POS1) vectorDistance (POS2) <= (DIST)
#define CHECK_POSTBRIEFING (getClientStateNumber > 9)
// #define CHECK_PREINIT if (!isServer) exitWith {}
// #define CHECK_POSTINIT if (!(EGVAR(main,enable)) || {!(GVAR(enable))} || {!isServer} || {!isMultiplayer}) exitWith {}

#define COMPARE_STR(STR1,STR2) ((STR1) == (STR2))
#define COMPARE_STR_CASE(STR1,STR2) ((STR1) isEqualTo (STR2))

// fob cost macros
#define COST_MAN 2
#define COST_CAR 7
#define COST_TANK 10
#define COST_AIR 14
#define COST_SHIP 7
#define COST_AMMO 0.1
#define COST_STRUCT 2
#define COST_ITEM 0.1
#define COST_FORT 0.2
#define COST_SIGN 0.1

// approval macros
#define AP_LOCATION_ID(LOCATION) ([QUOTE(PREFIX),"approval",LOCATION] joinString "_")
#define AP_MIN 0
#define AP_MAX 100
#define AP_DEFAULT AP_MAX*0.1
#define AP_CAR ((AP_MAX*0.005)*EGVAR(approval,multiplier))
#define AP_TANK ((AP_MAX*0.0075)*EGVAR(approval,multiplier))
#define AP_AIR ((AP_MAX*0.01)*EGVAR(approval,multiplier))
#define AP_SHIP ((AP_MAX*0.005)*EGVAR(approval,multiplier))
#define AP_MAN ((AP_MAX*0.001)*EGVAR(approval,multiplier))
#define AP_CIV ((AP_MAX*0.01)*EGVAR(approval,multiplier))
#define AP_FOB ((AP_MAX*0.0025)*EGVAR(approval,multiplier))
#define AP_VILLAGE ((AP_MAX*0.05)*EGVAR(approval,multiplier))
#define AP_CITY ((AP_MAX*0.1)*EGVAR(approval,multiplier))
#define AP_CAPITAL ((AP_MAX*0.15)*EGVAR(approval,multiplier))
#define AP_CONVERT1(POS) (linearConversion [AP_MIN, AP_MAX, [POS] call EFUNC(approval,getValue), 0, 1, true])
#define AP_CONVERT2(POS) (1 - ((1 - AP_CONVERT1(POS)) * 0.5))
