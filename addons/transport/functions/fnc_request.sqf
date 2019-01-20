/*
Author:
Nicholas Clark (SENSEI)

Description: 
player transport request

Arguments:
0: transport vehicle classname <STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(status) = TR_STATE_WAITING;

[TR_STR_EXFIL,true] call EFUNC(main,displayText);

[QGVAR(exfil), "onMapSingleClick", {
    params [
        ["_units",[],[[]]],
        ["_pos",[],[[0,0,0]]],
        ["_alt",false,[false]],
        ["_shift",false,[false]],
        ["_class","C_Heli_Light_01_civil_F",[""]]
    ];

    if (COMPARE_STR(GVAR(status),TR_STATE_WAITING)) then {
        if (surfaceIsWater _pos) then {
            [TR_STR_NOTLAND,true] call EFUNC(main,displayText);
        } else {
            _exfil = _pos isFlatEmpty [TR_CHECKDIST, 50, 0.45, 10, -1, false, player];

            if !(_exfil isEqualTo []) then {
                _exfil deleteAt 2;
                _exfilMrk = createMarker [MRK_EXFIL(name player),_exfil];
                _exfilMrk setMarkerType "mil_pickup";
                _exfilMrk setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor);
                _exfilMrk setMarkerText format ["EXTRACTION LZ (%1)",name player];

                [QGVAR(exfil), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
                [TR_STR_INFIL,true] call EFUNC(main,displayText);

                [QGVAR(infil), "onMapSingleClick", {
                    _class = _this select 4;
                    _exfil = _this select 5;
                    _exfilMrk = _this select 6;

                    if (COMPARE_STR(GVAR(status),TR_STATE_WAITING)) then {
                        if (surfaceIsWater _pos) then {
                            [TR_STR_NOTLAND,true] call EFUNC(main,displayText);
                        } else {
                            _infil = _pos isFlatEmpty [TR_CHECKDIST, 50, 0.45, 10, -1, false, player];

                            if !(_infil isEqualTo []) then {
                                if !(_infil inArea [_exfil, 1000, 1000, 0, false, -1]) then {
                                    _infil deleteAt 2;
                                    _infilMrk = createMarker [MRK_INFIL(name player),_infil];
                                    _infilMrk setMarkerType "mil_end";
                                    _infilMrk setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor);
                                    _infilMrk setMarkerText format ["INSERTION LZ (%1)",name player];

                                    [QGVAR(infil), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

                                    [QGVAR(request), [player,_class,_exfil,_infil,_exfilMrk,_infilMrk]] call CBA_fnc_serverEvent;
                                    
                                    GVAR(status) = TR_STATE_NOTREADY;
                                } else {
                                    [TR_STR_CLOSE,true] call EFUNC(main,displayText);
                                };
                            } else {
                                [TR_STR_BADTERRAIN,true] call EFUNC(main,displayText);
                            };
                        };
                    };
                },[_class,_exfil,_exfilMrk]] call BIS_fnc_addStackedEventHandler;
            } else {
                [TR_STR_BADTERRAIN,true] call EFUNC(main,displayText);
            };
        };
    };
},[_this select 0]] call BIS_fnc_addStackedEventHandler;

[
    {
        if !(COMPARE_STR(GVAR(status),TR_STATE_NOTREADY)) then {
            GVAR(status) = TR_STATE_READY;
            [TR_STR_CANCEL,true] call EFUNC(main,displayText);
            [QGVAR(exfil), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
            [QGVAR(infil), "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
            deleteMarker MRK_INFIL(name player);
            deleteMarker MRK_EXFIL(name player);
        };
    },
    [],
    30
] call CBA_fnc_waitAndExecute;

nil