/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

ADDON = false;

PREP(checkLoadout);
PREP(setRadio);
PREP(setRadioSettings);
PREP(setRadioACRE);
PREP(setRadioTFAR);

publicVariable QFUNC(checkLoadout);
publicVariable QFUNC(setRadio);
publicVariable QFUNC(setRadioSettings);
publicVariable QFUNC(setRadioACRE);
publicVariable QFUNC(setRadioTFAR);