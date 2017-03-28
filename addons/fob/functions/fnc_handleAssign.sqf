/*
Author:
Nicholas Clark (SENSEI)

Description:
assign FOB curator

Arguments:
0: curator <OBJECT>
1: unit <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_curator",objNull,[objNull,[]]],
	["_unit",objNull,[objNull,[]]]
];

private _previousCurator = getAssignedCuratorLogic _unit;

unassignCurator _curator;
unassignCurator _previousCurator;

// a delay between unassigning and assigning curator is required
[
    {
        INFO_3("Assigning unit: %1 to curator: %2. Previous assigned curator: %3",_this select 1,_this select 0,_this select 2);
        (_this select 1) assignCurator (_this select 0);
    },
    [_curator, _unit, _previousCurator],
    1
] call CBA_fnc_waitAndExecute;
