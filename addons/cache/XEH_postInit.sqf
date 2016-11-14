/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

CHECK_ADDON;

[FUNC(handleCache), 15, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;
