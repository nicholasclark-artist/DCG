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

private ["_unitCount","_groups","_composition"];

[GVAR(comms),{
    _unitCount = [4,16,GVAR(countCoef)] call EFUNC(main,getUnitCount);

    _groups = [_value,EGVAR(main,enemySide),_unitCount] call FUNC(spawnUnit);

    sleep _unitCount;

    // spawn composition after units so units are aware of buildings
    _composition = [_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS],"mil_comm",random 360,true] call EFUNC(main,spawnComposition);

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

        sleep 0.2
    } forEach (_groups select 0);

    // setvars
    _value setVariable [QGVAR(radius),_composition select 1];
    _value setVariable [QGVAR(composition),_composition select 2];
}] call CBA_fnc_hashEachPair;

nil