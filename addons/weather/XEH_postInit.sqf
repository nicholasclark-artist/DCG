/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

call FUNC(init);

[QGVAR(dateChange), {
    INFO("Date changed, adjusting initial forecast");

    GVAR(iDate) = date;
    
    private _forecast = [0] call FUNC(getForecast);

    GVAR(iOvercast) = _forecast select 0;
    GVAR(iRain) = _forecast select 1;
    GVAR(iFog) = _forecast select 2;
}] call CBA_fnc_addEventHandler;