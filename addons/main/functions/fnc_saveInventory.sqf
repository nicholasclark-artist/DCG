private ["_center","_path","_custom","_delete","_namespace","_name"];

_center = [_this,0,player,[objnull]] call bis_fnc_param;
_path = [_this,1,[],[[]]] call bis_fnc_param;
_custom = [_this,2,[],[[]]] call bis_fnc_param;
_delete = [_this,3,false,[false]] call bis_fnc_param;

_namespace = [_path,0,missionnamespace,[missionnamespace,grpnull,objnull]] call bis_fnc_paramin;
_name = [_path,1,"",[""]] call bis_fnc_paramin;

private ["_primaryWeaponMagazine","_secondaryWeaponMagazine","_handgunMagazine"];
_primaryWeaponMagazine = "";
_secondaryWeaponMagazine = "";
_handgunMagazine = "";
{
	if (count _x > 4 && {typename (_x select 4) == typename []}) then {
		private ["_weapon","_magazine"];
		_weapon = _x select 0;
		_magazine = _x select 4 select 0;
		switch _weapon do {
			case (primaryweapon _center): {_primaryWeaponMagazine = _magazine;};
			case (secondaryweapon _center): {_secondaryWeaponMagazine = _magazine;};
			case (handgunweapon _center): {_handgunMagazine = _magazine;};
		};
	};
} foreach weaponsitems _center;

private ["_export"];
_export = [
	[uniform _center,uniformitems _center],
	[vest _center,vestitems _center],
	[backpack _center,backpackitems _center],
	headgear _center,
	goggles _center,
	binocular _center,
	[primaryweapon _center,_center weaponaccessories primaryweapon _center,_primaryWeaponMagazine],
	[secondaryweapon _center,_center weaponaccessories secondaryweapon _center,_secondaryWeaponMagazine],
	[handgunweapon _center,_center weaponaccessories handgunweapon _center,_handgunMagazine],
	assigneditems _center - [binocular _center],
	_custom
];

private ["_data","_nameID"];
_data = _namespace getvariable ["bis_fnc_saveInventory_data",[]];
_nameID = _data find _name;
if (_delete) then {
	if (_nameID >= 0) then {
		_data set [_nameID,objnull];
		_data set [_nameID + 1,objnull];
		_data = _data - [objnull];
	};
} else {
	if (_nameID < 0) then {
		_nameID = count _data;
		_data set [_nameID,_name];
	};
	_data set [_nameID + 1,_export];
};
_namespace setvariable ["bis_fnc_saveInventory_data",_data];
profilenamespace setvariable ["bis_fnc_saveInventory_profile",true];
if !(isnil {profilenamespace getvariable "bis_fnc_saveInventory_profile"}) then {saveprofilenamespace};

_export