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

[[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_EXFIL,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);

[QGVAR(exfil),"onMapSingleClick",{
    params [
        ["_units",[],[[]]],
        ["_pos",[],[[0,0,0]]],
        ["_alt",false,[false]],
        ["_shift",false,[false]],
        ["_class","C_Heli_Light_01_civil_F",[""]]
    ];

    if (COMPARE_STR(GVAR(status),TR_STATE_WAITING)) then {
        if (surfaceIsWater _pos) then {
            [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_NOTLAND,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);
        } else {
            _exfil = _pos isFlatEmpty [TR_CHECKDIST,50,0.45,10,-1,false,player];

            if !(_exfil isEqualTo []) then {
                _exfil deleteAt 2;
                _exfilMrk = createMarker [MRK_EXFIL(name player),_exfil];
                _exfilMrk setMarkerType "mil_pickup";
                _exfilMrk setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor);
                _exfilMrk setMarkerText format ["EXTRACTION LZ (%1)",name player];

                [QGVAR(exfil),"onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
                [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_INFIL,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);

                [QGVAR(infil),"onMapSingleClick",{
                    _class = _this select 4;
                    _exfil = _this select 5;
                    _exfilMrk = _this select 6;

                    if (COMPARE_STR(GVAR(status),TR_STATE_WAITING)) then {
                        if (surfaceIsWater _pos) then {
                            [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_NOTLAND,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);
                        } else {
                            _infil = _pos isFlatEmpty [TR_CHECKDIST,50,0.45,10,-1,false,player];

                            if !(_infil isEqualTo []) then {
                                if !(_infil inArea [_exfil,1000,1000,0,false,-1]) then {
                                    _infil deleteAt 2;
                                    _infilMrk = createMarker [MRK_INFIL(name player),_infil];
                                    _infilMrk setMarkerType "mil_end";
                                    _infilMrk setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor);
                                    _infilMrk setMarkerText format ["INSERTION LZ (%1)",name player];

                                    [QGVAR(infil),"onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

                                    [QGVAR(request),[player,_class,_exfil,_infil,_exfilMrk,_infilMrk]] call CBA_fnc_serverEvent;

                                    GVAR(status) = TR_STATE_NOTREADY;
                                } else {
                                    [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_CLOSE,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);
                                };
                            } else {
                                [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_BADTERRAIN,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] call EFUNC(main,notify);
                            };
                        };
                    };
                },[_class,_exfil,_exfilMrk]] call BIS_fnc_addStackedEventHandler;
            } else {
                [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_BADTERRAIN,CBAN_BODY_SIZE,CBAN_BODY_COLOR],false] call EFUNC(main,notify);
            };
        };
    };
},[_this select 0]] call BIS_fnc_addStackedEventHandler;

[
    {
        if !(COMPARE_STR(GVAR(status),TR_STATE_NOTREADY)) then {
            GVAR(status) = TR_STATE_READY;
            [[COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[TR_STR_CANCEL,CBAN_BODY_SIZE,CBAN_BODY_COLOR],false] call EFUNC(main,notify);

            [QGVAR(exfil),"onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
            [QGVAR(infil),"onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
            deleteMarker MRK_INFIL(name player);
            deleteMarker MRK_EXFIL(name player);
        };
    },
    [],
    30
] call CBA_fnc_waitAndExecute;

nil