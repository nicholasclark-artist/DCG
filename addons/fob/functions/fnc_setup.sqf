/*
Author:
Nicholas Clark (SENSEI)

Description:
setup fob on server

Arguments:
0: unit to assign to curator <OBJECT>
1: fob position <ARRAY>
2: points available to curator <NUMBER>

Return:
none
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

params ["_unit","_pos",["_points",1]];

_pos set [2,0];
_revealed = [];
_mrkArray = [];

// create fob location on all machines
[_pos,{
 	GVAR(location) = createLocation ["NameLocal", _this, GVAR(range), GVAR(range)];
 	GVAR(location) setText format ["%1", GVAR(name)];
}] remoteExecCall ["BIS_fnc_call",0,true];

// assign unit and send unit curator UID
_unit assignCurator GVAR(curator);
GVAR(UID) = getPlayerUID _unit;
(owner _unit) publicVariableClient QGVAR(UID);

// setup curator
removeAllCuratorAddons GVAR(curator);
GVAR(curator) addCuratorAddons GVAR(addons);
GVAR(curator) addCuratorPoints _points;
GVAR(curator) setCuratorCoef ["Place", GVAR(placingMultiplier)];
GVAR(curator) setCuratorCoef ["Delete", GVAR(deletingMultiplier)];
GVAR(curator) setCuratorWaypointCost 0;
GVAR(curator) addCuratorEditingArea [0,_pos,GVAR(range)];
GVAR(curator) addCuratorCameraArea [0,_pos,GVAR(range)];
GVAR(curator) setCuratorCameraAreaCeiling 40;
[GVAR(curator),"object",["UnitPos","Rank","Lock"]] call BIS_fnc_setCuratorAttributes;

// create fob flag
GVAR(flag) = "Flag_NATO_F" createVehicle _pos;
GVAR(flag) setFlagTexture GVAR(flagTexturePath);

// setup eventhandlers, run on machine that owns curator
{
	GVAR(curator) removeAllEventHandlers "CuratorObjectRegistered";
	GVAR(curator) addEventHandler ["CuratorObjectRegistered",{
		private ["_playerSide","_costs","_side","_vehClass","_cost"];

		// _playerSide is the side of the player's class, not necessarily the player's side
		_playerSide = getNumber (configFile >> "CfgVehicles" >> typeOf getAssignedCuratorUnit GVAR(curator) >> "side");
		_costs = [];
		{
			// TODO following code may be missing a few vehicle classes that are relevant to an fob
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
		if (typeOf (_this select 1) in ARRAY_HQ && {{(typeOf _x in ARRAY_HQ)} count (curatorEditableObjects GVAR(curator)) isEqualTo 0}) then {
			["HQ deployed.\nAerial reconnaissance online.",true] remoteExecCall [QEFUNC(main,displayText), owner (getAssignedCuratorUnit GVAR(curator)), false];
		};
		if (CHECK_ADDON_2(approval)) then {
			// TODO add approval increase
		};
	}];

	GVAR(curator) removeAllEventHandlers "CuratorObjectDeleted";
	GVAR(curator) addEventHandler ["CuratorObjectDeleted",{
		if (typeOf (_this select 1) in ARRAY_HQ) then {
			if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) isEqualTo 0) then {
				["HQ removed.\nAerial reconnaissance offline.",true] remoteExecCall [QEFUNC(main,displayText), owner (getAssignedCuratorUnit GVAR(curator)), false];
			};
		};
		if (CHECK_ADDON_2(approval)) then {
			// TODO add approval decrease
		};
	}];
} remoteExecCall ["BIS_fnc_call",owner GVAR(curator),false];

// recon PFH
[{
	params ["_args","_idPFH"];
	_args params ["_revealed","_mrkArray","_flag"];

	if (GVAR(location) isEqualTo locationNull) exitWith { // exit when fob is dismantled
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		{
			deleteMarker _x;
		} forEach _mrkArray;
	};

	if ({typeOf _x in ARRAY_HQ} count (curatorEditableObjects GVAR(curator)) > 0) then {
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