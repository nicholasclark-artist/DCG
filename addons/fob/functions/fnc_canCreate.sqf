/*
Author:
Nicholas Clark (SENSEI)

Description:
check if player can deploy fob

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

!(FOB_DEPLOYED) && {isNull (objectParent player)} && {((getPosATL player) select 2) < 10}
