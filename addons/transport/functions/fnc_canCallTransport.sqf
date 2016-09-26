/*
Author:
Nicholas Clark (SENSEI)

Description:
check if player can call transport

Arguments:

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(ready) isEqualTo 1 && {GVAR(count) <= GVAR(maxCount)} && {cameraOn isEqualTo player}