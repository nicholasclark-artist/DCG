/*
Author:
Nicholas Clark (SENSEI)

Description:
steal intel from device

Arguments:

Return:
none
__________________________________________________________________*/

/*
only spawn at night
spawn civ informant in town
spawn enemies in town
spawn alarm in town
detection (firedNear EH triggers DCG_informantAlarm = true)
players must extract informant without detection
if detected spawn reinforcements and 2 techs
*/

#include "script_component.hpp"

_taskID = "informant";
_taskText = "Extract Informant";
_taskDescription = "";

if !(sunOrMoon < 1) exitWith {
	TASKEXIT(_taskID)
};

_town = DCG_locations select floor (random (count DCG_locations));
_townSize = size _town;
_avgTownSize = ((_townSize select 0) + (_townSize select 1))/2;
_townName = text _town;
_townPos = getpos _town;
_townPos set [2,0];

_houseArray = [_townPos,_radius] call DCG_fnc_findPosHouse;
if ((_houseArray select 1) isEqualTo []) exitWith {
	TASKEXIT(_taskID)
};
_pos1 = _houseArray select 1;