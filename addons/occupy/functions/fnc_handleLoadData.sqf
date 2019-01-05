/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:
0: saved data <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params ["_data"];

[[_data] call FUNC(findLocation),[] call FUNC(findLocation)] select (_data isEqualTo []);

nil