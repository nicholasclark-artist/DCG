/*
Author:
Nicholas Clark (SENSEI)

Description:
set unit in surrender stance

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define SURRENDER(UNIT,ANIM) \
	if (CHECK_ADDON_1("ace_captives")) then { \
		[UNIT,true] call ace_captives_fnc_setSurrendered; \
	} else { \
		UNIT playMoveNow ANIM; \
		if !(animationState UNIT isEqualTo ANIM) then { \
			UNIT switchMove ANIM; \
		}; \
	}

params ["_obj"];

if (!local _obj || {typeOf _obj isKindOf "Air"}) exitWith {};

if (typeOf _obj isKindOf "LandVehicle" || {typeOf _obj isKindOf "Ship"}) exitWith {
	_obj limitSpeed 0;
	crew _obj allowGetIn false;
	{
		_x setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
		moveOut _x;
		_x setVelocity [0, 0, 0];
		_x setBehaviour "CARELESS";
		SURRENDER(_x,"ACE_AmovPercMstpSsurWnonDnon");
		false
	} count (crew _obj);
};

_obj setVariable [QUOTE(DOUBLES(PREFIX,isOnPatrol)),0];
doStop _obj;
SURRENDER(_obj,"ACE_AmovPercMstpSsurWnonDnon");