/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define PREP_PRIM(TASK) PREP(TASK); GVAR(primaryList) pushBack QFUNC(TASK)
#define PREP_SEC(TASK) PREP(TASK); GVAR(secondaryList) pushBack QFUNC(TASK)

if !(CHECK_INIT) exitWith {};

ADDON = false;

GVAR(primaryList) = [];
GVAR(secondaryList) = [];

PREP(select);
PREP(cancel);
PREP(handleLoadData);

PREP_PRIM(prim_vip);
PREP_PRIM(prim_cache);
PREP_PRIM(prim_officer);
PREP_PRIM(prim_defend);
PREP_PRIM(prim_arty);
PREP_SEC(sec_deliver);
PREP_SEC(sec_repair);
PREP_SEC(sec_officer);
PREP_SEC(sec_intel01);
PREP_SEC(sec_intel02);
PREP_SEC(sec_tower01);

GVAR(primary) = [];
GVAR(secondary) = [];

publicVariable QFUNC(cancel);