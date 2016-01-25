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

GVAR(location) isEqualTo locationNull && {vehicle player isEqualTo player} && {((getPosATL player) select 2) < 2}