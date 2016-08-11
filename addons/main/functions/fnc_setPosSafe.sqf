/*
Author:
Nicholas Clark (SENSEI)

Description:
set object at safe position

Arguments:
0: object <OBJEECT>
1: position <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

(_this select 0) setDir 0;
(_this select 0) setVectorUp surfaceNormal (_this select 1);
(_this select 0) setPosASL (_this select 1);