/*
Author: SENSEI

Last modified: 1/23/2016

Description:

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SET_COST(COST) \
	if (GVAR(playerSideOnly)) then { \
		_cost = if (_side isEqualTo _playerSide || {_side isEqualTo 3}) then { \
			[true,COST] \
		} else { \
			[false,COST]; \
		}; \
	} else { \
		_cost = [true,COST]; \
	}

if !(isServer) exitWith {};

params ["_unit",["_points",1]];

_pos = getPosATL _unit;
_pos set [2,0];
_revealed = [];
_mrkArray = [];

[_pos,{
 	GVAR(location) = createLocation ["NameLocal", _this, GVAR(range), GVAR(range)];
 	GVAR(location) setText format ["%1", GVAR(name)];
}] remoteExecCall ["BIS_fnc_call",0,true];

removeAllCuratorAddons GVAR(curator);
GVAR(curator) addCuratorAddons GVAR(addons);
GVAR(curator) addCuratorPoints _points;
GVAR(curator) setCuratorCoef ["Place", GVAR(placingMultiplier)];
GVAR(curator) setCuratorCoef ["Delete", GVAR(deletingMultiplier)];
GVAR(curator) setCuratorWaypointCost 0;
GVAR(curator) addCuratorEditingArea [0,_pos,GVAR(range)];
GVAR(curator) addCuratorCameraArea [0,_pos,GVAR(range)];
GVAR(curator) setCuratorCameraAreaCeiling 40;
_unit assignCurator GVAR(curator);
GVAR(UID) = getPlayerUID _unit;
(owner _unit) publicVariableClient QGVAR(UID);

GVAR(flag) = "Flag_NATO_F" createVehicle _pos;
GVAR(flag) setFlagTexture GVAR(flagTexturePath);

[GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

GVAR(curator) removeAllEventHandlers "CuratorObjectRegistered";
GVAR(curator) addEventHandler ["CuratorObjectRegistered",{
		private ["_playerSide","_costs","_side","_vehClass","_cost"];
		_playerSide = getNumber (configFile >> "CfgVehicles" >> typeOf getAssignedCuratorUnit GVAR(curator) >> "side");
		_costs = [];
		{
			call {
				_side = getNumber (configFile >> "CfgVehicles" >> _x >> "side");
				_vehClass = toLower getText (configFile >> "CfgVehicles" >> _x >> "vehicleClass");
				if (_vehClass in ["men","menstory","menrecon","mendiver","mensniper","mensupport"]) exitWith {
					SET_COST(COST_MAN);
				};
				if (_vehClass in ["car","support"]) exitWith {
					SET_COST(COST_CAR);
				};
				if (_vehClass in ["armored"]) exitWith {
					SET_COST(COST_TANK);
				};
				if (_vehClass in ["air"]) exitWith {
					SET_COST(COST_AIR);
				};
				if (_vehClass in ["ship","submarine"]) exitWith {
					SET_COST(COST_SHIP);
				};
				if (_vehClass in ["ammo"]) exitWith {
					SET_COST(COST_AMMO);
				};
				if (_vehClass in ["structures","structures_military","structures_village","structures_infrastructure","structures_industrial"]) exitWith {
					SET_COST(COST_STRUCT);
				};
				if (_vehClass in ["fortifications"]) exitWith {
					SET_COST(COST_FORT);
				};
				if (_vehClass in ["signs"]) exitWith {
					SET_COST(COST_SIGN);
				};
				if (_vehClass in ["small_items","objects","furniture","tents"]) exitWith {
					SET_COST(COST_ITEM);
				};
				_cost = [true,1];
			};
			_costs pushBack _cost;
		} forEach (_this select 1);
		_costs
}];

GVAR(curator) removeAllEventHandlers "CuratorObjectPlaced";
GVAR(curator) addEventHandler ["CuratorObjectPlaced",{
	if (typeOf (_this select 1) in ARRAY_MED) then {
		(_this select 1) setVariable ["ace_medical_isMedicalFacility",true,true];
	};
	if (typeOf (_this select 1) in ARRAY_HQ && {!GVAR(hq)}) then {
		GVAR(hq) = true;
		["HQ deployed.\nAerial reconnaissance online.",true] remoteExecCall [QEFUNC(main,displayText), owner (getAssignedCuratorUnit GVAR(curator)), false];
	};
	/*if (CHECK_ADDON_2(approval)) then {
		EGVAR(approval,points) = EGVAR(approval,points) + 1;
		publicVariable QEGVAR(approval,points);
	};*/
}];

GVAR(curator) removeAllEventHandlers "CuratorObjectDeleted";
GVAR(curator) addEventHandler ["CuratorObjectDeleted",{
	if (typeOf (_this select 1) in ARRAY_HQ) then {
		if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) isEqualTo 0) then {
			GVAR(hq) = false;
			["HQ removed.\nAerial reconnaissance offline.",true] remoteExecCall [QEFUNC(main,displayText), owner (getAssignedCuratorUnit GVAR(curator)), false];
		};
	};
	/*if (CHECK_ADDON_2(approval)) then {
		EGVAR(approval,points) = EGVAR(approval,points) - 1;
		publicVariable QEGVAR(approval,points);
	};*/
}];

[{
	params ["_args","_idPFH"];
	_args params ["_revealed","_mrkArray","_flag"];

	if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[{
			params ["_args","_idPFH"];
			_args params ["_revealed","_mrkArray","_flag"];

			if (GVAR(location) isEqualTo locationNull) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				{
					deleteMarker _x;
				} forEach _mrkArray;
			};
			if (GVAR(hq)) then {
				{
					if (side _x isEqualTo EGVAR(main,enemySide) && {!(group _x in _revealed)} && {random 1 < 0.5}) exitWith {
						_hour = str (date select 3);
						_min = str (date select 4);
						if (count _min < 2) then {_min = "0"+_min};
						_format = _hour + ":" + _min;
						_mrk = createMarker [format["%1_%2_%3",QUOTE(ADDON),getposATL (leader _x),diag_tickTime],getposATL (leader _x)];
						_mrk setMarkerColor format ["Color%1",side _x];
						_mrk setMarkerType "o_unknown";
						_mrk setMarkerText format["%1",_format];
						_mrk setMarkerSize [0.75,0.75];
						_mrkArray pushBack _mrk;
						_revealed pushBack (group _x);
					};
				} forEach (MARKER_POS nearEntities [["Man","LandVehicle","Ship"], GVAR(rangeRecon)]);
			};
		}, GVAR(cooldownRecon), [_revealed,_mrkArray,_flag]] call CBA_fnc_addPerFrameHandler;
	};
}, 5, [_revealed,_mrkArray,_flag]] call CBA_fnc_addPerFrameHandler;