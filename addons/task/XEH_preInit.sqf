/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_PREINIT;

ADDON = false;

GVAR(primaryList) = [];
GVAR(secondaryList) = [];

PREP(initSettings);
PREP(select);
PREP(cancel);
PREP(handleDamage);
PREP(handleLoadData);
PREP(addItem);

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

publicVariable QFUNC(initSettings);
publicVariable QFUNC(cancel);

INITSETTINGS;
