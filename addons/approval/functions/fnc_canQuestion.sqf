/*
Author:
Nicholas Clark (SENSEI)

Description:
check if player can question target

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

(CHECK_VECTORDIST(getPosASL player,getPosASL cursorTarget,5) && {!isPlayer cursorTarget} && {cursorTarget isKindOf "CAManBase"})
