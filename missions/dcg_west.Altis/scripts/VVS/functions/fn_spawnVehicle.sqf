/*
	File: fn_spawnVehicle.sqf
	Author: Bryan "Tonic" Boardwine

	Edits by SENSEI

	Description:
	Spawns the selected vehicle, if a vehicle is already on the spawn point
	then it deletes the vehicle from the spawn point.
*/

disableSerialization;
private["_position","_direction","_className","_displayName","_spCheck","_cfgInfo","_spClear"];
if(lnbCurSelRow 38101 isEqualTo -1) exitWith {hint "You did not select a vehicle to spawn!"};

_className = lnbData[38101,[(lnbCurSelRow 38101),0]];
_displayName = lnbData[38101,[(lnbCurSelRow 38101),1]];
_position = getMarkerPos VVS_SP;
_direction = markerDir VVS_SP;
if (isNil "_position") exitWith {
	hint "The spawn position marker doesn't exist?";
};

closeDialog 0;

{deleteVehicle _x} count (nearestObjects [_position,["landVehicle","Air","Ship","ThingX"],(7 max (ceil(sizeOf _className)))]);
uiSleep 0.2;
_cfgInfo = [_className] call VVS_fnc_cfgInfo;
_vehicle = _className createVehicle [_position select 0,_position select 1,50];
_vehicle allowDamage false;
_vehicle setDir _direction;
if !(surfaceIsWater _position) then {
	_vehicle setPosATL _position;
} else {
	_vehicle setPosASL _position;
};
_vehicle setVectorUp [0,0,1];

if((_cfgInfo select 4) isEqualTo "Autonomous") then {
	createVehicleCrew _vehicle;
};
if(VVS_Checkbox) then {
	clearWeaponCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
};
if (getNumber (configfile >> "CfgVehicles" >> _className >> "attendant") isEqualTo 1) then {
	_vehicle setVariable ["ace_medical_isMedicalFacility", true, true];
};
_vehicle allowDamage true;