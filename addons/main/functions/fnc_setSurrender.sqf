/*
Author:
Nicholas Clark (SENSEI)

Description:
set unit in surrender stance

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define SURRENDER(UNIT,ANIM) \
	if (CHECK_ADDON_1("ace_captives")) then { \
		[UNIT,true] call ace_captives_fnc_setSurrendered; \
	} else { \
		[UNIT,ANIM] call FUNC(setAnim); \
	}

params [
    ["_obj",objNull,[objNull]]
];

if (!local _obj || {typeOf _obj isKindOf "Air"}) exitWith {false};

if (typeOf _obj isKindOf "LandVehicle") exitWith {
	_obj limitSpeed 0;
	crew _obj allowGetIn false;
	{
		moveOut _x;
		_x setVelocity [0, 0, 0];
		_x setBehaviour "CARELESS";
		SURRENDER(_x,"AmovPercMstpSsurWnonDnon");
		false
	} count (crew _obj);

    true
};

if (typeOf _obj isKindOf "Ship") exitWith {
	_obj limitSpeed 0;
	{
		_x setBehaviour "CARELESS";
		false
	} count (crew _obj);

    true
};

doStop _obj;
_obj setBehaviour "CARELESS";
SURRENDER(_obj,"AmovPercMstpSsurWnonDnon");

true
