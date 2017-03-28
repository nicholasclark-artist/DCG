/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:
0: data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if !(_this isEqualTo []) then {
	_this call FUNC(findLocation);
} else {
	[] call FUNC(findLocation);
};
