/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

[FUNC(handleCache), 30, []] call CBA_fnc_addPerFrameHandler;
