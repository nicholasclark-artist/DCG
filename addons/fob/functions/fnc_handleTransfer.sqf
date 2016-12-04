/*
Author:
Nicholas Clark (SENSEI)

Description:
handles fob control transfer

Arguments:
0: unit currently in control <OBJECT>
1: unit to receive control <OBJECT>
2: if new unit needs client setup <BOOL>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_old",objNull,[objNull]],
    ["_new",objNull,[objNull]],
    ["_handleNew",false]
];

unassignCurator GVAR(curator);

// a delay between unassigning and assigning curator is required
[
    {
        (_this select 0) assignCurator GVAR(curator);
    },
    [_new],
    2
] call CBA_fnc_waitAndExecute;

[
    {getAssignedCuratorUnit GVAR(curator) isEqualTo (_this select 0)},
    {
        [(curatorEditableObjects GVAR(curator)),owner (_this select 0)] call EFUNC(main,setOwner); // set object locality to new unit, otherwise non local objects lag when edited

        [
            [name (_this select 1),_this select 2],
            {
                if (_this select 1) then {
                    call FUNC(handleClient);
                };

                call FUNC(curatorEH);

                _format = format ["%2 has transferred FOB control to you \n \nPress [%1] to start building",call FUNC(getKeybind), (_this select 0)];

                [_format,true] call EFUNC(main,displayText);
            }
        ] remoteExecCall [QUOTE(BIS_fnc_call),owner (_this select 0), false];
    },
    [_new,_old,_handleNew]
] call CBA_fnc_waitUntilAndExecute;
