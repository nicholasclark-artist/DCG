/*
Author:
Nicholas Clark (SENSEI)

Description:
handle halting unit

Arguments:
0: unit <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

doStop (_this select 0);

sleep 15;

(_this select 0) doFollow leader (_this select 0);

false
