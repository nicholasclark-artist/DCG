/*
Author: SENSEI

Last modified: 1/20/2016

Description: add amount to value

Return: number
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(value) = GVAR(value) + _this;
publicVariable QGVAR(value);