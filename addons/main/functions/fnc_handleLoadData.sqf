/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _data = [QUOTE(ADDON)] call FUNC(loadDataAddon);

if !(_data isEqualTo []) then {
    // @todo add support for loading units
    {
        _x params ["_type","_pos","_dir","_vector","_vars"];

        private _veh = _type createVehicle DEFAULT_SPAWNPOS;

        {
            _veh setVariable [_x select 0, _x select 1, false];
        } forEach _vars;

        _veh setDir _dir;
        [_veh,_pos] call FUNC(setPosSafe);
    } forEach _data;
};

nil