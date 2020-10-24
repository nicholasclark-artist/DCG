/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn comm array, should not be called directly and must run in scheduled environment

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

// @todo add IR strobe and sfx to hint at comm array location
[GVAR(comms),{
    private _unitCount = [4,12,GVAR(countCoef)] call EFUNC(main,getUnitCount);

    private _groups = [_value,EGVAR(main,enemySide),_unitCount] call FUNC(spawnUnit);

    sleep _unitCount;

    // spawn composition after units so units are aware of buildings
    private _composition = [_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS],"mil_comm",random 360,true] call EFUNC(main,spawnComposition);

    // set groups to defend composition
    {
        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                [_this select 0,getPos (_this select 1),50,0] call EFUNC(main,taskDefend);
                [QEGVAR(cache,enableGroup),_this select 0] call CBA_fnc_serverEvent;
            },
            [_x,_value],
            _unitCount * 2
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2;
    } forEach (_groups select 0);

    // setup switch
    private _switch = ((_composition select 2) select {toLower typeOf _x in COMM_ITEMS}) select 0;

    if !(isNil "_switch") then {
        [_switch] remoteExecCall [QUOTE(removeAllActions),0,false];
        _switch animateSource ["switchposition",1];

        [[_key,_switch],{
            if (hasInterface) then {
                params ["_key","_switch"];

                [
                    QGVAR(disableComm),
                    "Disable Communications",
                    {
                        TRACE_1("",_this);
                        // [QGVAR(disableComm),[_key,_switch]] call CBA_fnc_serverEvent;
                    },
                    {true},
                    {},
                    _this,
                    _switch,
                    0,
                    ["ACE_MainActions"],
                    [0,0,0],
                    2
                ] call EFUNC(main,setAction);
            };
        }] remoteExecCall [QUOTE(call),0];
    } else {
        ERROR_1("%1 is missing a suitable switch object",_composition select 0);
    };

    // setvars
    _value setVariable [QGVAR(radius),_composition select 1];
    _value setVariable [QGVAR(composition),_composition select 2];

    private _mrk = createMarker [format["%1%2",_key,_value getVariable [QGVAR(type),""]],getPos _value];
    _mrk setMarkerType "o_maint";
    _mrk setMarkerColor ([EGVAR(main,enemySide),true] call BIS_fnc_sideColor);
    _mrk setMarkerSize [0.75,0.75];
    _mrk setMarkerText (_composition select 0);
    [_mrk] call EFUNC(main,setDebugMarker);
}] call CBA_fnc_hashEachPair;

nil