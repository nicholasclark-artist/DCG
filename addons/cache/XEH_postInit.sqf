/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[FUNC(handleCache), 30, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;
