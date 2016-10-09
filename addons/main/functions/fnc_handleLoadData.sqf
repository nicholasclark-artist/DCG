/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:
0: data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_data"];

if !(_data isEqualTo []) then {
	{
		_x params ["_type","_pos","_dir","_vector"];

		_veh = _type createVehicle [0,0,0];
		_veh setDir _dir;
		_veh setPosASL _pos;
		_veh setVectorUp _vector;

		false
	} count _data;
};