/*
Author:
Nicholas Clark (SENSEI)

Description:
transfers objects to a requested owner

Arguments:
0: objects to transfer <OBJECT,ARRAY>
1: machine to receive objects <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_obj","_id"];

{
	if !(isNull group _x) then {
		if !(groupOwner group _x isEqualTo _id) then {
			group _x setGroupOwner _id;
			LOG_DEBUG_2("Transferring group %1 to %2.",group _x,_id);
		};
	} else {
		_x setOwner _id;
		LOG_DEBUG_2("Transferring %1 to %2.",typeOf _x,_id);
	};
	false
} count _obj;