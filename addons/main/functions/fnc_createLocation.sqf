/*
Author:
Nicholas Clark (SENSEI)

Description:
create location locally

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_pos",[0,0,0],[[]]],
	["_type","NameCity",[""]],
	["_size",100,[0]],
	["_name","",[""]],
	["_id","_loc",[""]]
];

call compile (format [
	"%1 = createLocation [%3, %4, %5, %5];
	if !(%2 isEqualTo '') then {
 		%1 setText %2;
	};",
	_id,str _name,str _type, _pos, _size
]);