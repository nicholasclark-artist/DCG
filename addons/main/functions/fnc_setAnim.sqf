/*
Author:
Nicholas Clark (SENSEI)

Description:
set unit animation

Arguments:
0: unit <OBJECT>
1: animation <STRING>
2: force animation <BOOL>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_unit",
	"_anim",
	["_force",false]
];

_unit playMoveNow _anim;

if (_force) then {
	[_unit,_anim] remoteExecCall [QUOTE(switchMove),0,false];
};