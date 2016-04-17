/*
Author:
Nicholas Clark (SENSEI)

Description:
check approval on client

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_approvalArray","_stance","_suicide","_rebel"];

_approvalArray = call FUNC(handler);
_stance = _approvalArray select (count _approvalArray - 1); // always last element in array
_suicide = _approvalArray select 0;
_rebel = _approvalArray select 1;

[format["%2\nCivilian Approval: %3\nChance of Suicide Attack: %4%%1\nChance of Rebel Activity: %5%1","%",_stance,round DCG_approval,(str _suicide), (str _rebel)],true] call EFUNC(main,displayText);