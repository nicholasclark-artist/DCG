/*
Author:
Nicholas Clark (SENSEI)

Description:
delete fob

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define DELETE_HINT format ["Are you sure you want to dismantle %1?", GVAR(name)]
#define CONFIRMED_HINT format ["%1 dismantled.", GVAR(name)]

[] spawn {
	closeDialog 0;
	_ret = [
		parseText (format ["<t align='center'>%1</t>",DELETE_HINT]),
		TITLE,
		"Yes",
		"No"
	] call bis_fnc_GUImessage;

	if (_ret) then {
		GVAR(UID) = "";

		{
			{_x call EFUNC(main,cleanup)} forEach (curatorEditableObjects GVAR(curator));
			[getPosASL GVAR(anchor),AV_FOB*-1] call EFUNC(approval,addValue);
			unassignCurator GVAR(curator);
			[false] call FUNC(recon);
			deleteVehicle GVAR(anchor);
		} remoteExecCall [QUOTE(BIS_fnc_call), 2, false];

		{
			deleteLocation GVAR(location);
		} remoteExecCall [QUOTE(BIS_fnc_call), 0, false];

		[CONFIRMED_HINT,true] call EFUNC(main,displayText);
	};
};