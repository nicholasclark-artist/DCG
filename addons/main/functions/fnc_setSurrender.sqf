/*
Author: SENSEI

Last modified: 1/15/2016

Description: set unit in surrender stance

Return: nothing
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
		_x setVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),true];
		moveOut _x;
		_x setVelocity [0, 0, 0];
		_x setBehaviour "CARELESS";
		SURRENDER(_x,"ACE_AmovPercMstpSsurWnonDnon");
		false
	} count (crew _obj);
};

_obj setVariable [QUOTE(DOUBLES(PREFIX,patrol_exit)),true];
doStop _obj;
SURRENDER(_obj,"ACE_AmovPercMstpSsurWnonDnon");