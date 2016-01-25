/*
Author:
Nicholas Clark (SENSEI)

Description:
switches an array of units to another side and groups them

Arguments:

Return:
group
__________________________________________________________________*/
#include "script_component.hpp"

private ["_side","_newgrp"];

_units = param [0,[],[[]]];
_side = param [1,GVAR(enemySide)];

_newgrp = createGroup _side;

{
	[_x] joinSilent grpNull;
	[_x] joinSilent _newgrp;
	false
} count _units;

_newgrp