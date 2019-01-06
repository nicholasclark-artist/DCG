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

if !(_data isEqualTo []) then {
    [_data select 0,_data select 1] call FUNC(handleCreate);

    {
        _veh = (_x select 0) createVehicle [0,0,0];
        _veh setDir (_x select 2);
        [_veh,_pos] call EFUNC(main,setPosSafe);
        GVAR(curator) addCuratorEditableObjects [[_veh],false];
    } forEach (_data select 2);
};

nil