/*
Author:
Nicholas Clark (SENSEI)

Description:
handles fob control requests

Arguments:
0: unit that initiated request <OBJECT>
1: request answer <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define FORMAT_SETUP \
	GVAR(response), \
	GVAR(ID1), \
	GVAR(ID2), \
	QEFUNC(main,removeAction), \
	missionNamespace setVariable [PVEH_REQUEST,[player,GVAR(response)]], \
	publicVariableServer str PVEH_REQUEST

if (!isServer) exitWith {};

private "_userName";

_userName = "SERVER";

if (count _this isEqualTo 1) exitWith {
	[_this select 0, {
		GVAR(response) = -1;
		GVAR(ID1) = -1;
		GVAR(ID2) = -1;

		[format ["%1 requests control of %2.",name _this,GVAR(name)],true] call EFUNC(main,displayText);

		GVAR(ID1) = [format ["%1_requestAccept",QUOTE(ADDON)],"Accept Request",format [
			"
				%1 = 1;
				[player,1,%2] call %4;
				[player,1,%3] call %4;
				%5;
				%6;
			",
			FORMAT_SETUP
		],"true","",player,1,ACTIONPATH] call EFUNC(main,setAction);

		GVAR(ID2) = [format ["%1_requestDeny",QUOTE(ADDON)],"Deny Request",format [
			"
				%1 = 0;
				[player,1,%2] call %4;
				[player,1,%3] call %4;
				%5;
				%6;
			",
			FORMAT_SETUP
		],"true","",player,1,ACTIONPATH] call EFUNC(main,setAction);

		[
			{
				if (GVAR(response) isEqualTo -1) then { // unit did not answer request
					[player,1,GVAR(ID1)] call EFUNC(main,removeAction);
					[player,1,GVAR(ID2)] call EFUNC(main,removeAction);
					missionNamespace setVariable [PVEH_REQUEST,[player,GVAR(response)]];
					publicVariableServer PVEH_REQUEST;
				};
			},
			[],
			60
		] call CBA_fnc_waitAndExecute;
	}] remoteExecCall [QUOTE(BIS_fnc_call), owner (getAssignedCuratorUnit GVAR(curator))];
};

if !(isNull (getAssignedCuratorUnit GVAR(curator))) then {
	_userName = name (getAssignedCuratorUnit GVAR(curator));
};

if ((_this select 1) isEqualTo 1) then { // if current curator unit accepts request
	GVAR(UID) = "";
	(owner (getAssignedCuratorUnit GVAR(curator))) publicVariableClient QGVAR(UID); // reset UID on current curator unit
	unassignCurator GVAR(curator);
	(_this select 0) assignCurator GVAR(curator);

	[
		{(getAssignedCuratorUnit GVAR(curator)) isEqualTo (_this select 0)},
		{
			GVAR(UID) = getPlayerUID (_this select 0);
			(owner (_this select 0)) publicVariableClient QGVAR(UID);
			(owner (_this select 0)) publicVariableClient QUOTE(RECON);
			remoteExecCall [QFUNC(curatorEH), owner (_this select 0), false];
			[(curatorEditableObjects GVAR(curator)),owner (_this select 0)] call EFUNC(main,setOwner); // set object locality to new unit, otherwise non local objects lag when edited
		},
		[_this select 0]
	] call CBA_fnc_waitUntilAndExecute;
};

[[_userName,_this select 1],{
	if ((_this select 1) isEqualTo 0) exitWith {
		[format ["%1 denies your request.", (_this select 0)],true] call EFUNC(main,displayText);
	};

	if ((_this select 1) isEqualTo 1) exitWith {
		 _entry = [ADDON_TITLE, BUILD_ID] call CBA_fnc_getKeybind;

		if (!isNil "_entry") then {
			private _keyStr = "";
			private _key = call compile (keyName ((_entry select 5) select 0));
			private _modifiers = (_entry select 5) select 1;
			private _modArr = [];

			if (_modifiers select 0) then {
				_modArr pushBack "SHIFT";
			};
			if (_modifiers select 1) then {
				_modArr pushBack "CTRL";
			};
			if (_modifiers select 2) then {
				_modArr pushBack "ALT";
			};

			_keyStr = _modArr joinString " ";
			_keyStr = format ["%1 + %2", _keyStr,_key];

			private _format = format ["
			%2 accepts your request \n \n
			Press [%1] to start building. \n
			Regional approval is affected by FOB readiness. \n
			Aerial reconnaissance online.
			",_keyStr,(_this select 0)];

			[_format,true] call EFUNC(main,displayText);
		};
	};

	[format ["%1 did not answer your request.", (_this select 0)],true] call EFUNC(main,displayText);
}] remoteExecCall [QUOTE(BIS_fnc_call), owner (_this select 0)];