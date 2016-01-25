/*
	File: fn_openVVS.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Opens the VVS menu and fills in the blanks.
*/
private["_sp"];
/*_sp = [_this,3,"",["",[]]] call BIS_fnc_param;*/
_sp = _this;

if(typeName _sp isEqualTo "STRING") then
{
	if(_sp isEqualTo "") exitWith {closeDialog 0};
	VVS_SP = _sp;
}
	else
{
	if(typeName _sp isEqualTo "ARRAY") then
	{
		if(count _sp isEqualTo 0) exitWith {closeDialog 0;};
		VVS_SP = _sp select 0;
		VVS_Cfg = _sp select 1;
	};
};
disableSerialization;
if(!(createDialog "VVS_Menu")) exitWith {}; //Couldn't create the menu