// Written by Kochleffel
// Adapted by Code34
// Adapted by EightySix
// Adapted by WhiteRaven
// Adapted by SENSEI

// if (!local player) exitWith {};

private ["_crew","_text","_vehicle","_role","_name","_ctrl"];
disableSerialization;
uiNamespace setVariable ['crewdisplay', objnull];

[{
	if (isNull (uiNamespace getVariable "crewdisplay")) then {
		2 cutrsc ["infomessage", "PLAIN"];
	};
	_text = "";
	if !(vehicle player isEqualTo player) then {
		if !(visibleMap) then {
			_crew = crew (vehicle player);
			_vehicle = vehicle player;
			_name = getText (configFile >> "CfgVehicles" >> (typeOf vehicle player) >> "DisplayName");
			_text = format ["<t size='1.35' shadow='2' color='#FFFFFF'>%1</t><br/>", _name];
			{
				if(!(format["%1", name _x] isEqualTo "") && {!(format["%1", name _x] isEqualTo "Error: No unit")}) then {
					_role = assignedVehicleRole _x;
					call {
						if (_x isEqualTo (commander _vehicle)) exitWith {
							_text=_text+format ["<t size='1.35' shadow='2' color='#FFFFFF'>%1</t> <t size='1.5'><img image='media\hud_commander.paa'></t><br/>", name _x];
						};
						if (_x isEqualTo (driver _vehicle)) exitWith {
							_text=_text+format ["<t size='1.35' shadow='2' color='#FFFFFF'>%1</t> <t size='1.5'><img image='media\hud_driver.paa'></t><br/>", name _x];
						};
						if (toLower(_role select 0) isEqualTo "turret") then {
							if ((_role select 1) isEqualTo [0] && !(gunner _vehicle isEqualTo _x)) then {
								_text=_text+format ["<t size='1.35' shadow='2' color='#FFFFFF'>%1</t> <t size='1.5'><img image='media\hud_cargo.paa'></t><br/>", name _x];
							} else {
								_text=_text+format ["<t size='1.35' shadow='2' color='#a5a5a5'>%1</t> <t size='1.5'><img image='media\hud_gunner.paa'></t><br/>", name _x];
							};
						};
						if (toLower(_role select 0) isEqualTo "cargo") then {
							if (isNil {_role select 1}) then {
								_text=_text+format ["<t size='1.35' shadow='2' color='#FFFFFF'>%1</t> <t size='1.5'><img image='media\hud_cargo.paa'></t><br/>", name _x];
							} else {
								_text=_text+format ["<t size='1.35' shadow='2' color='#FFFFFF'>%1</t> <t size='1.5'><img image='media\hud_ffv.paa'></t><br/>", name _x];
							};
						};
					};
				};
			} forEach _crew;
		} else {
			_text = "";
		};
	};
	_ctrl = (uiNamespace getVariable 'crewdisplay') displayCtrl 102;
	_ctrl ctrlSetStructuredText parseText _text;
}, 1, []] call CBA_fnc_addPerFrameHandler;