/*
Author:
Nicholas Clark (SENSEI)
Description:
handles player transport request
Arguments:
Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

[STR_EXFIL,true] call EFUNC(main,displayText);

[EH_EXFIL, "onMapSingleClick", {
	_class = _this select 0;
	if !(GVAR(wait)) then {
		GVAR(wait) = true;
		if (surfaceIsWater _pos) then {
			[STR_NOTLAND,true] call EFUNC(main,displayText);
			GVAR(wait) = false;
		} else {
			_exfil = _pos isFlatEmpty [TR_CHECKDIST, 50, 0.45, 10, -1, false, player];
			if !(_exfil isEqualTo []) then {
				_exfil set [2,0];
				_exfilMrk = createMarker [MRK_EXFIL(name player),_exfil];
				_exfilMrk setMarkerType "mil_pickup";
				_exfilMrk setMarkerColor format ["Color%1", side player];
				_exfilMrk setMarkerText format ["EXTRACTION LZ (%1)",name player];
				GVAR(wait) = false;
				[EH_EXFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
				[STR_INFIL,true] call EFUNC(main,displayText);

				[EH_INFIL, "onMapSingleClick", {
					_class = _this select 0;
					_exfil = _this select 1;
					_exfilMrk = _this select 2;

					if !(GVAR(wait)) then {
						GVAR(wait) = true;
						if (surfaceIsWater _pos) then {
							[STR_NOTLAND,true] call EFUNC(main,displayText);
							GVAR(wait) = false;
						} else {
							_infil = _pos isFlatEmpty [TR_CHECKDIST, 50, 0.45, 10, -1, false, player];
							if !(_infil isEqualTo []) then {
								if (_exfil distance2D _infil >= 1000) then {
									_infil set [2,0];
									_infilMrk = createMarker [MRK_INFIL(name player),_infil];
									_infilMrk setMarkerType "mil_end";
									_infilMrk setMarkerColor format ["Color%1", side player];
									_infilMrk setMarkerText format ["INSERTION LZ (%1)",name player];
									GVAR(wait) = false;
									[EH_INFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
                                    missionNamespace setVariable [PVEH_REQUEST,[player,_class,_exfil,_infil,_exfilMrk,_infilMrk]];
                                    publicVariableServer PVEH_REQUEST;
								} else {
									[STR_CLOSE,true] call EFUNC(main,displayText);
									GVAR(wait) = false;
								};
							} else {
								[STR_BADTERRAIN,true] call EFUNC(main,displayText);
								GVAR(wait) = false;
							};
						};
					};
				},[_class,_exfil,_exfilMrk]] call BIS_fnc_addStackedEventHandler;
			} else {
				[STR_BADTERRAIN,true] call EFUNC(main,displayText);
				GVAR(wait) = false;
			};
		};
	};
},[(_this select 0)]] call BIS_fnc_addStackedEventHandler;

[
	{
		if (GVAR(ready) isEqualTo 1) then {
			[STR_CANCEL,true] call EFUNC(main,displayText);
			GVAR(wait) = false;
			[EH_EXFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			[EH_INFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			deleteMarker MRK_INFIL(name player);
			deleteMarker MRK_EXFIL(name player);
		};
	},
	[],
	90
] call CBA_fnc_waitAndExecute;
