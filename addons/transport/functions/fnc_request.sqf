/*
Author:
Nicholas Clark (SENSEI)

Description: player transport request

Arguments:
0: transport vehicle classname <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(status) = TR_WAITING;

[STR_EXFIL,true] call EFUNC(main,displayText);

[EH_EXFIL, "onMapSingleClick", {
	_class = _this select 0;
	if (COMPARE_STR(GVAR(status),TR_WAITING)) then {
		if (surfaceIsWater _pos) then {
			[STR_NOTLAND,true] call EFUNC(main,displayText);
		} else {
			_exfil = _pos isFlatEmpty [TR_CHECKDIST, 50, 0.45, 10, -1, false, player];

			if !(_exfil isEqualTo []) then {
				_exfil deleteAt 2;
				_exfilMrk = createMarker [MRK_EXFIL(name player),_exfil];
				_exfilMrk setMarkerType "mil_pickup";
				_exfilMrk setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor);
				_exfilMrk setMarkerText format ["EXTRACTION LZ (%1)",name player];

				[EH_EXFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
				[STR_INFIL,true] call EFUNC(main,displayText);

				[EH_INFIL, "onMapSingleClick", {
					_class = _this select 0;
					_exfil = _this select 1;
					_exfilMrk = _this select 2;

					if (COMPARE_STR(GVAR(status),TR_WAITING)) then {
						if (surfaceIsWater _pos) then {
							[STR_NOTLAND,true] call EFUNC(main,displayText);
						} else {
							_infil = _pos isFlatEmpty [TR_CHECKDIST, 50, 0.45, 10, -1, false, player];

							if !(_infil isEqualTo []) then {
								if !(_infil inArea [_exfil, 1000, 1000, 0, false, -1]) then {
									_infil deleteAt 2;
									_infilMrk = createMarker [MRK_INFIL(name player),_infil];
									_infilMrk setMarkerType "mil_end";
									_infilMrk setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor);
									_infilMrk setMarkerText format ["INSERTION LZ (%1)",name player];

									[EH_INFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
                                    missionNamespace setVariable [PVEH_REQUEST,[player,_class,_exfil,_infil,_exfilMrk,_infilMrk]];
                            		publicVariableServer PVEH_REQUEST;
								} else {
									[STR_CLOSE,true] call EFUNC(main,displayText);
								};
							} else {
								[STR_BADTERRAIN,true] call EFUNC(main,displayText);
							};
						};
					};
				},[_class,_exfil,_exfilMrk]] call BIS_fnc_addStackedEventHandler;
			} else {
				[STR_BADTERRAIN,true] call EFUNC(main,displayText);
			};
		};
	};
},[_this select 0]] call BIS_fnc_addStackedEventHandler;

[
	{
		if !(COMPARE_STR(GVAR(status),TR_NOTREADY)) then {
            GVAR(status) = TR_READY;
			[STR_CANCEL,true] call EFUNC(main,displayText);
			[EH_EXFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			[EH_INFIL, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			deleteMarker MRK_INFIL(name player);
			deleteMarker MRK_EXFIL(name player);
		};
	},
	[],
	90
] call CBA_fnc_waitAndExecute;
