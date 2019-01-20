/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

PREINIT;

PREP(initSettings);
PREP(handleLoadout);
PREP(setRadio);
PREP(setRadioSettings);
PREP(setRadioACRE);
PREP(setRadioTFAR);

publicVariable QFUNC(handleLoadout);
publicVariable QFUNC(setRadio);
publicVariable QFUNC(setRadioSettings);
publicVariable QFUNC(setRadioACRE);
publicVariable QFUNC(setRadioTFAR);

SETTINGS_INIT;
