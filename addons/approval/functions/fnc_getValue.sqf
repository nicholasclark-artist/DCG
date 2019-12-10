/*
Author:
Nicholas Clark (SENSEI)

Description:
get region approval value

Arguments:
0: region <ARRAY,LOCATION>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_region",locationNull,[locationNull,[]]]
];

_a = [[_region] call FUNC(getRegion),_region] select (_region isEqualType locationNull);

TRACE_1("",_a);

([[_region] call FUNC(getRegion),_region] select (_region isEqualType locationNull)) getVariable [QGVAR(value),0]