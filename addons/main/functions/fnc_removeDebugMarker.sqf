/*
Author:
Nicholas Clark (SENSEI)

Description:
delete debug marker

Arguments:
0: marker <STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _marker = _this select 0;

GVAR(debugMarkers) deleteAt (GVAR(debugMarkers) find _marker);
deleteMarker _marker;

nil