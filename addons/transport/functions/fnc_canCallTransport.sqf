/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/12/2015

Description: check if player can call transport

Return: boolean
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(ready) isEqualTo 1 && {GVAR(count) <= GVAR(maxCount)}