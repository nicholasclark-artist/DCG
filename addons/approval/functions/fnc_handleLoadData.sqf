/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading addon data

Arguments:
0: loaded data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define REGION_SIZE 2000

params [
    ["_data",[],[[]]]
];

{
    private _value = if (count _data > _forEachIndex + 1) then {
        _data select _forEachIndex
    } else {
        AV_DEFAULT
    };

    private _location = createLocation ["Name", ASLtoAGL _x, REGION_SIZE, REGION_SIZE];
    _location setRectangular true;
    _location setVariable [QGVAR(regionValue),_value];
    GVAR(regions) pushBack _location;
} forEach ([EGVAR(main,center),REGION_SIZE*2,worldSize] call EFUNC(main,findPosGrid));
