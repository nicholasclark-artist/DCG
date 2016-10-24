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

[[],{
	LOG("Init radio settings.");

	call FUNC(checkLoadout);
	call FUNC(setRadioSettings);
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];