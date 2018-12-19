/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[
	{MAIN_ADDON},
	{
		_data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);
	}
] call CBA_fnc_waitUntilAndExecute;

// ADDON = true;
