/*
Author:
Nicholas Clark (SENSEI)

Description:
get cardinal direction

Arguments:
0: direction in azimuth degrees <NUMBER>

Return:
string
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_dir",0,[0]]
];

private _degrees = [0,45,90,135,180,225,270,315,360] apply {abs (_dir - _x)};

["North","North-East","East","South-East","South","South-West","West","North-West","North"] select (_degrees find (selectMin _degrees))