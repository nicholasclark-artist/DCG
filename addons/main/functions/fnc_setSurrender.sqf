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
        if (CHECK_ADDON_1("ace_captives")) then {
            [_x,true] call ace_captives_fnc_setSurrendered;
        } else {
            [_x,"AmovPercMstpSsurWnonDnon"] call FUNC(setAnim);
        };
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

if (CHECK_ADDON_1("ace_captives")) then {
    [_obj,true] call ace_captives_fnc_setSurrendered;
} else {
    [_obj,"AmovPercMstpSsurWnonDnon"] call FUNC(setAnim);
};

true
