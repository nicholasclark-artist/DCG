/*
Author:
Nicholas Clark (SENSEI)

Description:
send server create eventhandler

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define ANIM "AinvPknlMstpSnonWnonDnon_medic4"
#define ANIM_TIME 9

if !([player modelToWorld [0,3,0],4,0] call EFUNC(main,isPosSafe)) exitWith {
	[format ["Select an open area to deploy %1.",GVAR(name)],true] call EFUNC(main,displayText);
};

[player,ANIM] call EFUNC(main,setAnim);

[{
    _format = format ["%2 Deployed \n \nPress [%1] to start building",call FUNC(getKeybind), GVAR(name)];
    [_format,true] call EFUNC(main,displayText);

	missionNamespace setVariable [PVEH_CREATE,player];
	publicVariableServer PVEH_CREATE;
}, [], ANIM_TIME] call CBA_fnc_waitAndExecute;
