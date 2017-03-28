/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main) && {time > 0}},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

        [] spawn {
            setDate GVAR(date);
            0 setOvercast GVAR(overcast);
            forceWeatherChange; // causes big bad lag
        };
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
