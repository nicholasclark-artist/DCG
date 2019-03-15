#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\x\cba\addons\xeh\script_xeh.hpp"

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) FUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
    #define PREP_VOR(fncName) FUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\voronoi\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
    #define PREP_VOR(fncName) [QPATHTOF(functions\voronoi\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define PREP_MODULE(folder) [] call compile preprocessFileLineNumbers QPATHTOF(folder\__PREP__.sqf)
#define MSG_EXIT QUOTE(Exiting: ADDON version: VERSION)

#define PREINIT if (!isServer && {hasInterface}) exitWith {}; LOG(MSG_INIT)
#define POSTINIT if (!isMultiplayer || {!isServer && hasInterface}) exitWith {}

// variable macros
#define GETVAR_SYS(var1,var2) getVariable [ARR_2(QUOTE(var1),var2)]
#define SETVAR_SYS(var1,var2) setVariable [ARR_2(QUOTE(var1),var2)]
#define SETPVAR_SYS(var1,var2) setVariable [ARR_3(QUOTE(var1),var2,true)]

#undef GETVAR
#define GETVAR(var1,var2,var3) (var1 GETVAR_SYS(var2,var3))
#define GETMVAR(var1,var2) (missionNamespace GETVAR_SYS(var1,var2))
#define GETUVAR(var1,var2) (uiNamespace GETVAR_SYS(var1,var2))
#define GETPRVAR(var1,var2) (profileNamespace GETVAR_SYS(var1,var2))
#define GETPAVAR(var1,var2) (parsingNamespace GETVAR_SYS(var1,var2))

#undef SETVAR
#define SETVAR(var1,var2,var3) var1 SETVAR_SYS(var2,var3)
#define SETPVAR(var1,var2,var3) var1 SETPVAR_SYS(var2,var3)
#define SETMVAR(var1,var2) missionNamespace SETVAR_SYS(var1,var2)
#define SETUVAR(var1,var2) uiNamespace SETVAR_SYS(var1,var2)
#define SETPRVAR(var1,var2) profileNamespace SETVAR_SYS(var1,var2)
#define SETPAVAR(var1,var2) parsingNamespace SETVAR_SYS(var1,var2)

#define GETGVAR(var1,var2) GETMVAR(GVAR(var1),var2)
#define GETEGVAR(var1,var2,var3) GETMVAR(EGVAR(var1,var2),var3)

// heaps
// Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)

// Min/max switch, comment for a min heap, uncomment for a max heap
#define MAX_HEAP

#define HEAP_NODEPARAMS(x) (x) params ["_key", "_value"]
#define HEAP_NODE_KEY 0
#define HEAP_NODE_VALUE 1

#ifdef MAX_HEAP
    //Max heap
    #define HEAP_INFINITY 1e39
    #define HEAP_UNDEFINED_KEY -HEAP_INFINITY
    #define HEAP_G_TOP_KEY HEAP_INFINITY

    #define HEAP_COMPARE(x,y) ((x) > (y))
#else
    //Min heap
    #define HEAP_INFINITY 1e39
    #define HEAP_UNDEFINED_KEY HEAP_INFINITY
    #define HEAP_G_TOP_KEY -HEAP_INFINITY

    #define HEAP_COMPARE(x,y) ((x) < (y))
#endif

#define HEAP_KEY(x) ((x) select HEAP_NODE_KEY)
#define HEAP_VALUE(x) ((x) select HEAP_NODE_VALUE)
#define HEAP_PARENT(x) (floor (((x)-1)/2))
#define HEAP_LEFT(x) (2*(x)+1)
#define HEAP_RIGHT(x) (2*(x)+2)
#define HEAP_LAST(x) ((count (x))-1)

// checks
#define CHECK_DEBUG (EGVAR(main,debug) isEqualTo 1)
#define CHECK_MARKER(MARKER) (getMarkerColor MARKER != '')
#define CHECK_ADDON_1(PATCH) (isClass (configfile >> QUOTE(CfgPatches) >> QUOTE(PATCH)))
#define CHECK_ADDON_2(VAR) (CHECK_ADDON_1(GVARMAIN(VAR)) && EGVAR(VAR,enable))
#define CHECK_DIST(POS1,POS2,DIST) (POS1) distance (POS2) <= (DIST)
#define CHECK_DIST2D(POS1,POS2,DIST) (POS1) distance2D (POS2) <= (DIST)
#define CHECK_VECTORDIST(POS1,POS2,DIST) (POS1) vectorDistance (POS2) <= (DIST)
#define CHECK_INGAME (getClientStateNumber > 9)
#define CHECK_HC (!hasInterface && !isServer)

// compares 
#define COMPARE_STR(STR1,STR2) ((STR1) == (STR2))
#define COMPARE_STR_CASE(STR1,STR2) ((STR1) isEqualTo (STR2))

// terrain expressions 
#define EX_HOUSES "houses * (1 - meadow * 2)"
#define EX_MEADOW "meadow * (1 - forest) * (1 - sea) * (1 - houses * 3)"
#define EX_FOREST "(forest + trees) * (1 - meadow * 3)"
#define EX_HILL "hills * (1 - meadow * 3)"
#define EX_COAST "sea - waterDepth"

// misc
#define ASLZ(POS) ((getTerrainHeightASL POS) max 0)
#define DEFAULT_SPAWNPOS [0,0,worldsize]
#define PROBABILITY(CHANCE) (((CHANCE min 1) max 0) > random 1)
#define ACTIONPATH [QUOTE(DOUBLES(ACE,SelfActions)),QGVARMAIN(actions),QUOTE(ADDON)]
#define SETTINGS_INIT publicVariable QFUNC(initSettings); remoteExecCall [QFUNC(initSettings), -2, true]; call FUNC(initSettings)

// fob cost
#define FOB_COST_MAN 2
#define FOB_COST_CAR 7
#define FOB_COST_TANK 10
#define FOB_COST_AIR 14
#define FOB_COST_SHIP 7
#define FOB_COST_AMMO 0.1
#define FOB_COST_STRUCT 2
#define FOB_COST_ITEM 0.1
#define FOB_COST_FORT 0.2
#define FOB_COST_SIGN 0.1

// approval
#define AP_MIN 0
#define AP_MAX 100
#define AP_DEFAULT AP_MAX*0.1
#define AP_CAR ((AP_MAX*0.005)*EGVAR(approval,multiplier))
#define AP_TANK ((AP_MAX*0.0075)*EGVAR(approval,multiplier))
#define AP_AIR ((AP_MAX*0.01)*EGVAR(approval,multiplier))
#define AP_SHIP ((AP_MAX*0.005)*EGVAR(approval,multiplier))
#define AP_MAN ((AP_MAX*0.001)*EGVAR(approval,multiplier))
#define AP_CIV ((AP_MAX*0.05)*EGVAR(approval,multiplier))
#define AP_FOB ((AP_MAX*0.0025)*EGVAR(approval,multiplier))
#define AP_VILLAGE ((AP_MAX*0.05)*EGVAR(approval,multiplier))
#define AP_CITY ((AP_MAX*0.1)*EGVAR(approval,multiplier))
#define AP_CAPITAL ((AP_MAX*0.15)*EGVAR(approval,multiplier))
#define AP_CONVERT1(POS) (linearConversion [AP_MIN, AP_MAX, ([POS] call EFUNC(approval,getRegion)) select 1 select 1, 0, 1, true])
#define AP_CONVERT2(POS) ((1 - AP_CONVERT1(POS)) * 0.5)
