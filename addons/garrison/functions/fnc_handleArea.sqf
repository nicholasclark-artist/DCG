/*
Author:
Nicholas Clark (SENSEI)

Description:

Arguments:

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

_cleared = true;

// get status of area
[GVAR(areas),{
    _outpost = [GVAR(outposts),_key] call CBA_fnc_hashGet;
    _garrison = [GVAR(garrisons),_key] call CBA_fnc_hashGet;
    _comms = [GVAR(comms),_key] call CBA_fnc_hashGet;
    
    // check outpost status
    if (_outpost getVariable [QGVAR(unitCountCurrent),0] isEqualTo 0) then {
        _outpost setVariable [QGVAR(active),0];
        [_outpost getVariable [QGVAR(task),""],"SUCCEEDED",true] call BIS_fnc_taskSetState;
    } else {
        _cleared = false;
    };

    // check garrison status
    if (_garrison getVariable [QGVAR(unitCountCurrent),0] isEqualTo 0) then {
        _garrison setVariable [QGVAR(active),0];
        [_garrison getVariable [QGVAR(task),""],"SUCCEEDED",true] call BIS_fnc_taskSetState;
    } else {
        _cleared = false;
    };
}] call CBA_fnc_hashEachPair;

// if all areas clear, set new ao with cooldown
if (_cleared) exitWith {
    call FUNC(removeArea);

    [{
        call FUNC(setArea);
    }, [], GVAR(cooldown)] call CBA_fnc_waitAndExecute;
};

// handle comms and dynamic tasks 
[GVAR(areas),{
    _outpost = [GVAR(outposts),_key] call CBA_fnc_hashGet;
    _garrison = [GVAR(garrisons),_key] call CBA_fnc_hashGet;
    _comms = [GVAR(comms),_key] call CBA_fnc_hashGet;
    
    if (_comms getVariable [QGVAR(active),1] isEqualTo 0) then {
        _garrison setVariable [QGVAR(reinforce),0];
        [_comms getVariable [QGVAR(task),""],"SUCCEEDED",true] call BIS_fnc_taskSetState;
    }; 

    {
        if (combatMode _x isEqualTo "RED") exitWith {
            INFO_1("reinforce %1",_key)
        };
    } forEach (_garrison getVariable [QGVAR(groups),[]]);
}] call CBA_fnc_hashEachPair;

nil