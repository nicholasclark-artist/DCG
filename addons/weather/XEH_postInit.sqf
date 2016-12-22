/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		setDate GVAR(date);
		GVAR(overcast) call BIS_fnc_setOvercast;
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
