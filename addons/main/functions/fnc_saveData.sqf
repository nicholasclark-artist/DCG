/*
Author:
Nicholas Clark (SENSEI)

Description:
save data to server profile

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define PUSHBACK_DATA(ADDONTOSAVE,DATATOSAVE) \
	INFO_2("Saving %1: %2.",QUOTE(DOUBLES(PREFIX,ADDONTOSAVE)),DATATOSAVE); \
	GVAR(saveDataCurrent) pushBack [QUOTE(DOUBLES(PREFIX,ADDONTOSAVE)),DATATOSAVE]

if !(isServer) exitWith {};

// overwrite current data
GVAR(saveDataCurrent) = [DATA_MISSION_ID];

// don't need to check for main addon, it's always enabled
private _data = [];

{
	if (!(_x isKindOf "Man") && {!(_x isKindOf "Logic")}) then {
		if (_x getVariable [DATA_OBJVAR,false]) then {
			_data pushBack [typeOf _x,getPosASL _x,getDir _x,vectorUp _x];
		};
	};
} foreach (allMissionObjects "All");

PUSHBACK_DATA(main,_data);

if (CHECK_ADDON_2(occupy)) then {
	private _data = [];

	for "_i" from 0 to count EGVAR(occupy,locations) - 1 do {
		(EGVAR(occupy,locations) select _i) params ["_name","_position","_size","_type"];
		private _infCount = 0;
		private _vehCount = 0;
		private _airCount = 0;
		{
			if ((driver _x) getVariable [QUOTE(TRIPLES(PREFIX,occupy,unit)),false]) then {
				if (_x isKindOf "Man") exitWith {
					_infCount = _infCount + 1;
				};
				if (_x isKindOf "LandVehicle") exitWith {
					_vehCount = _vehCount + 1;
				};
				if (_x isKindOf "Air") exitWith {
					_airCount = _airCount + 1;
				};
			};
			false
		} count (_position nearEntities [["Man","LandVehicle","Air"],_size*2]);

		_data pushBack [_name,_position,_size,_type,[_infCount,_vehCount,_airCount]];
	};

	PUSHBACK_DATA(occupy,_data);
};

if (CHECK_ADDON_2(fob)) then {
	private _data = [];

	if !(EGVAR(fob,location) isEqualTo locationNull) then {
		_data pushBack (locationPosition EGVAR(fob,location));
		_data pushBack (curatorPoints EGVAR(fob,curator));
		private _dataObj = [];
		private _refund = 0;
		{
			if (!(_x isKindOf "Man") && {!(_x isKindOf "Logic")} && {count crew _x isEqualTo 0}) then {
				_dataObj pushBack [typeOf _x,getPosASL _x,getDir _x,vectorUp _x];
			} else {
				call {
					if (_x isKindOf "Man") exitWith {
						_refund = _refund + abs(COST_MAN*EGVAR(fob,deleteCoef));
					};
					if (_x isKindOf "Car") exitWith {
						_refund = _refund + abs(COST_CAR*EGVAR(fob,deleteCoef));
					};
					if (_x isKindOf "Tank") exitWith {
						_refund = _refund + abs(COST_TANK*EGVAR(fob,deleteCoef));
					};
					if (_x isKindOf "Air") exitWith {
						_refund = _refund + abs(COST_AIR*EGVAR(fob,deleteCoef));
					};
					if (_x isKindOf "Ship") exitWith {
						_refund = _refund + abs(COST_SHIP*EGVAR(fob,deleteCoef));
					};
				};
			};
			false
		} count (curatorEditableObjects EGVAR(fob,curator));

		_data pushBack _dataObj;
		_refund = ((_data select 1) + _refund) min 1;
		_data set [1,_refund];
		//_data pushBack [EGVAR(fob,AVBonus)];
	};

	PUSHBACK_DATA(fob,_data);
};

if (CHECK_ADDON_2(weather)) then {
	private _data = [overcast,date];

	PUSHBACK_DATA(weather,_data);
};

if (CHECK_ADDON_2(ied)) then {
	private _data = [];
	{
		private _pos =+ getPos _x;
		_pos deleteAt 2;
		_data pushBack _pos;
		false
	} count EGVAR(ied,list);

	PUSHBACK_DATA(ied,_data);
};

if (CHECK_ADDON_2(task)) then {
	private _data = [EGVAR(task,primary),EGVAR(task,secondary)];

	PUSHBACK_DATA(task,_data);
};

if (CHECK_ADDON_2(approval)) then {
    private _data = [];

    {
        _data pushBack (_x getVariable [QEGVAR(approval,regionValue),AV_DEFAULT]);
    } forEach EGVAR(approval,region);

	PUSHBACK_DATA(approval,_data);
};

// following code must run last
private _dataProfile = DATA_GETVAR;

if !(_dataProfile isEqualTo []) then {
	{
		if (toUpper (_x select 0) isEqualTo DATA_MISSION_ID) exitWith {
			_dataProfile set [_forEachIndex,GVAR(saveDataCurrent)];
		};
		_dataProfile pushBack GVAR(saveDataCurrent);
	} forEach _dataProfile;
} else {
	_dataProfile pushBack GVAR(saveDataCurrent);
};

DATA_SETVAR(_dataProfile);
saveProfileNamespace;
