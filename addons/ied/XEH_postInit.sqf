/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define TYPE_EXP ["R_TBG32V_F","HelicopterExploSmall"]

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[{
			if (GVAR(list) isEqualTo []) exitWith {
				[_this select 1] call CBA_fnc_removePerFrameHandler;
			};

			{
				_ied = _x;
				_near = _ied nearEntities [["Man", "LandVehicle"], 4];
				_near = _near select {isPlayer _x};

				if !(_near isEqualTo []) then {
					GVAR(list) deleteAt (GVAR(list) find _ied);
					(selectRandom TYPE_EXP) createVehicle (getPosATL _ied);
					deleteVehicle _ied;
				};

				false
			} count GVAR(list);
		}, 1.25, []] call CBA_fnc_addPerFrameHandler;
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
