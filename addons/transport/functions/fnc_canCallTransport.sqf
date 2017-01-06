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

COMPARE_STR(GVAR(status),TR_READY) && {GVAR(count) <= ceil GVAR(maxCount)} && {cameraOn isEqualTo player}
