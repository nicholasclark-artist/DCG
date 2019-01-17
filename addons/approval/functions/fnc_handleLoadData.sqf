/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading addon data

Arguments:
0: saved data <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define REGION_SIZE (worldSize/round(worldSize/6000))

params [
    ["_data",[],[[]]]
];

{
    private _value = if (count _data > _forEachIndex + 1) then {
        _data select _forEachIndex
    } else {
        AP_DEFAULT
    };

    private _location = createLocation ["Name", ASLtoAGL _x, REGION_SIZE*0.5, REGION_SIZE*0.5];
    _location setRectangular true;
    _location setVariable [QGVAR(regionValue),_value];
    
    GVAR(regions) pushBack _location;
} forEach ([EGVAR(main,center),REGION_SIZE,worldSize] call EFUNC(main,findPosGrid));

nil