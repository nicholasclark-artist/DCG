/*
Author: Nicholas Clark (SENSEI)

Description:
transfers objects to a requested owner

Arguments:

Return:
none
__________________________________________________________________*/
if (!isServer) exitWith {};

#include "script_component.hpp"

if (typeName (_this select 0) isEqualTo "ARRAY") then {
	{
		_x setOwner (_this select 1);
		LOG_DEBUG_2("Transferring %1 to %2.",typeOf _x,(_this select 1));
		false
	} count (_this select 0);
} else {
	(_this select 0) setOwner (_this select 1);
	LOG_DEBUG_2("Transferring %1 to %2.",typeOf (_this select 0),(_this select 1));
};