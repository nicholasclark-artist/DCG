/*
Author:
Nicholas Clark (SENSEI)

Description:
set object at safe position (positionASL)

Arguments:
0: object <OBJEECT>
1: position <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj",objNull,[objNull]],
    ["_pos",DEFAULT_POS,[[]]]
];

// force positionASL,allow underwater positions
if (count _pos isEqualTo 2 || {(_pos select 2) > 0}) then {
    _pos =+ _pos; 
    _pos set [2,ASLZ(_pos)];
};

// center object on position
_pos = [_pos,_obj] call FUNC(getPosOffset);

// snap to normal and set position
_obj setVectorUp surfaceNormal _pos;
_obj setPosASL _pos;

nil