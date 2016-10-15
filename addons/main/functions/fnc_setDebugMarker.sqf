/*
Author:
Nicholas Clark (SENSEI)

Description:
send marker to debug handler

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _marker = _this select 0;

_marker setMarkerAlpha 0;
GVAR(debugMarkers) pushBack _marker;