/*
Author:
Nicholas Clark (SENSEI)

Description:

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

[{
	{
		if (!(isNull _x) && {count units _x > 0}) then {
			private ["_mrk"];
			_mrk = createMarker [format["%1_%2_tracking",QUOTE(ADDON),getposATL leader _x],getposATL leader _x];
			_mrk setMarkerSize [0.5,0.5];
			_mrk setMarkerColor format ["Color%1", side _x];
			if !(vehicle leader _x isEqualTo leader _x) then {
				_mrk setMarkerType "o_armor";
			} else {
				_mrk setMarkerType "o_inf";
			};
		};
		false
	} count GVAR(groups);
}, 30, []] call CBA_fnc_addPerFrameHandler;