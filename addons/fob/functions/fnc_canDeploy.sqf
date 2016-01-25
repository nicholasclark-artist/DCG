/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/23/2015

Description: can deploy fob

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(location) isEqualTo locationNull && {vehicle player isEqualTo player} && {((getPosATL player) select 2) < 2}