scopename _fnc_scriptName;

private ["_cfg","_inventory","_isCfg","_blacklist"];

_object = [_this,0,objnull,[objnull]] call bis_fnc_param;
_cfg = [_this,1,configfile,[configfile,"",[]]] call bis_fnc_param;
_blacklist = [_this,2,[],[[]]] call bis_fnc_param;
_inventory = [];

switch (typename _cfg) do {
	case (typename ""): {
		_cfg = configfile >> "cfgvehicles" >> _cfg;
	};
	case (typename []): {
		if ({typename _x != typename ""} count _cfg == 0) then {
			_cfg = [_cfg,configfile] call bis_fnc_configpath;
		} else {
			if (count _cfg == 1) then {
				_inventory = _cfg select 0;
			} else {
				private ["_namespace","_name","_data","_nameID"];
				_namespace = [_cfg,0,missionnamespace,[missionnamespace,grpnull,objnull]] call bis_fnc_paramin;
				_name = [_cfg,1,"",[""]] call bis_fnc_paramin;
				_data = _namespace getvariable ["bis_fnc_saveInventory_data",[]];
				_nameID = _data find _name;
				if (_nameID >= 0) then {
					_inventory = _data select (_nameID + 1);
					_cfg = [_inventory];
				} else {
					["Inventory '%1' not found",_name] call bis_fnc_error; breakout _fnc_scriptName;
				};
			};
		};
	};
};
_isCfg = count _inventory == 0;

{_blacklist set [_foreachindex,tolower _x];} foreach _blacklist;

if !(local _object) exitwith {[[_object,_cfg,_blacklist],_fnc_scriptName,_object] call bis_fnc_mp; false};

private ["_items","_linkedItemsMisc","_vest","_headgear","_goggles"];
_items = [];
_linkedItemsMisc = [];
_vest = "";
_headgear = "";
_goggles = "";
if (_isCfg) then {
	_items = getarray (_cfg >> "items");
	_linkedItems = getarray (_cfg >> "linkedItems");
	_linkedItemsMisc = [];
	{
		_item = _x;
		if (typename _item == typename []) then {_item = _item call bis_fnc_selectrandom;};

		if (isclass (configfile >> "cfgglasses" >> _item)) then {
			_goggles = _item;
		} else {
			private ["_type"];
			_type = getnumber (configfile >> "cfgweapons" >> _item >> "iteminfo" >> "type");
			switch _type do {
				case 701: {_vest = _item;};
				case 605: {_headgear = _item;};

				default {_linkedItemsMisc set [count _linkedItemsMisc,_item];};
			};
		};
	} foreach _linkedItems;
} else {
	_vest = _inventory select 1 select 0;
	_headgear = _inventory select 3;
	_goggles = _inventory select 4;

	_linkedItemsMisc = (_inventory select 9);
	if (!isnil {_inventory select 6 select 1}) then {_linkedItemsMisc = _linkedItemsMisc + (_inventory select 6 select 1)} else {_linkedItemsMisc = _linkedItemsMisc + ["","",""];};
	if (!isnil {_inventory select 7 select 1}) then {_linkedItemsMisc = _linkedItemsMisc + (_inventory select 7 select 1)} else {_linkedItemsMisc = _linkedItemsMisc + ["","",""];};
	if (!isnil {_inventory select 8 select 1}) then {_linkedItemsMisc = _linkedItemsMisc + (_inventory select 8 select 1)} else {_linkedItemsMisc = _linkedItemsMisc + ["","",""];};
};

if !("uniform" in _blacklist) then {
	removeuniform _object;
};
if !("vest" in _blacklist) then {
	removevest _object;
};
if !("headgear" in _blacklist) then {
	removeheadgear _object;
};
if !("goggles" in _blacklist) then {
	removegoggles _object;
};
if !("backpack" in _blacklist) then {
	removebackpack _object;
};
if !("items" in _blacklist) then {
	removeallitems _object;
};
if !("linkeditems" in _blacklist) then {
	private["_headgear","_goggles"];

	_headgear = headgear _object;
	_goggles = goggles _object;

	removeallassigneditems _object;

	sleep 0.1;

	if (_headgear != "") then
	{
	_object addheadgear _headgear;
	};
	if (_goggles != "") then
	{
	_object addgoggles _goggles;
	};
};
if !("weapons" in _blacklist) then {
	removeallweapons _object;
};
if !("transportMagazines" in _blacklist) then {
	if (count (getmagazinecargo _object select 0) > 0) then {clearmagazinecargoglobal _object;};
};
if !("transportWeapons" in _blacklist) then {
	if (count (getweaponcargo _object select 0) > 0) then {clearweaponcargoglobal _object;};
};
if !("transportItems" in _blacklist) then {
	if (count (getitemcargo _object select 0) > 0) then {clearitemcargoglobal _object;};
};

sleep 0.1;

if !("uniform" in _blacklist) then {
	private ["_uniform"];
	_uniform = "";
	if (_isCfg) then {
		_uniform = _cfg >> "uniformClass";
		_uniform = if (isarray _uniform) then {(getarray _uniform) call bis_fnc_selectrandom} else {gettext _uniform};
	} else {
		_uniform = _inventory select 0 select 0;
	};
	if (_uniform != "") then {
		if (isclass (configfile >> "cfgWeapons" >> _uniform)) then {
			_object forceadduniform _uniform;
		} else {
			["Uniform '%1' does not exist in CfgWeapons",_uniform] call bis_fnc_error;
		};
	};
};
if !("vest" in _blacklist) then {
	if (_vest != "") then {
		if (isclass (configfile >> "cfgWeapons" >> _vest)) then {
			_object addvest _vest;
		} else {
			["Vest '%1' does not exist in CfgWeapons",_vest] call bis_fnc_error;
		};
	};
};
if !("headgear" in _blacklist) then {
	if (_headgear != "") then {
		if (isclass (configfile >> "cfgWeapons" >> _headgear)) then {
			_object addheadgear _headgear;
		} else {
			["Headgear '%1' does not exist in CfgWeapons",_headgear] call bis_fnc_error;
		};
	};
};
if !("goggles" in _blacklist) then {
	if (_goggles != "") then {
		if (isclass (configfile >> "cfgGlasses" >> _goggles)) then {
			_object addgoggles _goggles;
		} else {
			["Goggles '%1' does not exist in CfgGlasses",_goggles] call bis_fnc_error;
		};
	};
};
if !("backpack" in _blacklist) then {
	private ["_backpack"];
	_backpack = "";
	if (_isCfg) then {
		_backpack = _cfg >> "backpack";
		_backpack = if (isarray _backpack) then {(getarray _backpack) call bis_fnc_selectrandom} else {gettext _backpack};
	} else {
		_backpack = _inventory select 2 select 0;
	};
	if (_backpack == "") then {
		removeBackpack _object;
	} else {
		if (isclass (configfile >> "cfgVehicles" >> _backpack)) then {
			_object addbackpack _backpack;
			if (!(_isCfg)) then {clearAllItemsFromBackpack _object};
		} else {
			["Backpack '%1' does not exist in CfgVehicles",_backpack] call bis_fnc_error;
		};
	};
};
if !("magazines" in _blacklist) then {
	if (_isCfg) then {
		private ["_magazines"];
		_magazines = getarray (_cfg >> "magazines");
		{
			if (_x != "") then {
				_magazine = _x;
			if (typename _magazine == typename []) then {_magazine = _magazine call bis_fnc_selectrandom;};
				_object addmagazine _magazine;
			};
		} foreach _magazines;
	} else {
		if ({!isnil "_x"} count (_inventory select 6) > 2) then {
			{
				if (_x != "") then {_object addmagazine _x;};
			} foreach [_inventory select 6 select 2,_inventory select 7 select 2,_inventory select 8 select 2];
		};
	};
};
if !("weapons" in _blacklist) then {
	private ["_weapons"];
	_weapons = if (_isCfg) then {getarray (_cfg >> "weapons")} else {[_inventory select 5,_inventory select 6 select 0,_inventory select 7 select 0,_inventory select 8 select 0]};
	{
		if (_x != "") then {
			_weapon = _x;
		if (typename _weapon == typename []) then {_weapon = _weapon call bis_fnc_selectrandom;};
			_object addweapon _weapon;
		};
	} foreach _weapons;
};
if !(_isCfg) then {
	if !("uniform" in _blacklist) then {{_object additemtouniform _x;} foreach (_inventory select 0 select 1);};
	if !("vest" in _blacklist) then {{_object additemtovest _x;} foreach (_inventory select 1 select 1);};
	if !("backpack" in _blacklist) then {{_object additemtobackpack _x;} foreach (_inventory select 2 select 1);};
};
if !("transportMagazines" in _blacklist) then {
	if (_isCfg) then {
		private ["_transportMagazines"];
		_transportMagazines = [];
		{
			_transportMagazines set [count _transportMagazines,[gettext (_x >> "magazine"),getnumber (_x >> "count")]];
		} foreach ([_cfg >> "transportMagazines"] call bis_fnc_subclasses);
		{
			if ((_x select 0) != "") then {
			_object addmagazinecargoglobal _x;
			};
		} foreach _transportMagazines;
	};
};
if !("items" in _blacklist) then {
	{
		if (_x != "") then {
			_object additem _x;
		};
	} foreach _items;
};
if !("linkeditems" in _blacklist) then {
	{
		if (_x != "") then {
			_object linkitem _x;
			_object addPrimaryWeaponItem _x;
			_object addSecondaryWeaponItem _x;
			_object addHandgunItem _x;
		};
	} foreach _linkedItemsMisc;
};
if !("transportWeapons" in _blacklist) then {
	if (_isCfg) then {
		private ["_transportWeapons"];
		_transportWeapons = [];
		{
			_transportWeapons set [count _transportWeapons,[gettext (_x >> "weapon"),getnumber (_x >> "count")]];
		} foreach ([_cfg >> "transportWeapons"] call bis_fnc_subclasses);
		{
			if ((_x select 0) != "") then {
				_object addweaponcargoglobal _x;
			};
		} foreach _transportWeapons;
	};
};
if !("transportItems" in _blacklist) then {
	if (_isCfg) then {
		private ["_transportItems"];
		_transportItems = [];
		{
			_transportItems set [count _transportItems,[gettext (_x >> "name"),getnumber (_x >> "count")]];
		} foreach ([_cfg >> "transportItems"] call bis_fnc_subclasses);
		{
			if ((_x select 0) != "") then {
			_object additemcargoglobal _x;
			};
		} foreach _transportItems;
	};
};
true