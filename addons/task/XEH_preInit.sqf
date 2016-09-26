/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(select);
PREP(cancel);

PREP(prim_vip);
PREP(prim_cache);
PREP(prim_officer);
PREP(prim_defend);
PREP(prim_arty);
PREP(sec_deliver);
PREP(sec_repair);
PREP(sec_officer);
PREP(sec_intel01);
PREP(sec_intel02);

GVAR(primaryList) = [
	QFUNC(prim_vip),
	QFUNC(prim_cache),
	QFUNC(prim_officer),
	QFUNC(prim_arty),
	QFUNC(prim_defend)
];
GVAR(secondaryList) = [
    QFUNC(sec_deliver),
    QFUNC(sec_repair),
    QFUNC(sec_officer),
    QFUNC(sec_intel01),
    QFUNC(sec_intel02)
];
GVAR(primary) = [];
GVAR(secondary) = [];

publicVariable QFUNC(cancel);