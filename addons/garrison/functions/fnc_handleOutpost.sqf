/*
Author:
Nicholas Clark (SENSEI)

Description:

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define GAR_COOLDOWN 300

// run on all outposts
[GVAR(locations),{
    private _polygon = _value getVariable [QGVAR(polygon),[]];
    private _id = _value getVariable [QGVAR(id),""];
    private _officer = _value getVariable [QGVAR(officer),objNull];
    private _unitCount = _value getVariable [QGVAR(unitCount),GAR_UNITCOUNT];
    private _unitCountCurrent = _value getVariable [QGVAR(unitCountCurrent),0];
    private _comms = _value getVariable [QGVAR(commsArray),1];
    private _reinforce = _value getVariable [QGVAR(reinforce),0];

    // clear outpost if all units dead
    if (_unitCountCurrent < 1) then {
        GVAR(cleared) = GVAR(cleared) + 1;
        // set ao to safe on map unless task in ao
        // cleanup
    };

    if (_comms < 1) then {
        _value setVariable [QGVAR(reinforce),0];
    };

    // start reinforcement loop if comms up during combat
    if (_comms > 0 && {combatMode (group _officer) isEqualTo "RED"}) then {
        _value setVariable [QGVAR(reinforce),1];
        // spawn reinforcement handler
    };
}] call CBA_fnc_hashEachPair;

// set new ao without cooldown
if (GVAR(cleared) < 0) exitWith {
    call FUNC(setArea);   
};

// set new ao with cooldown
if (GVAR(cleared) isEqualTo count ([GVAR(locations)] call CBA_fnc_hashKeys)) then {
    // remove old ao

    [{
        call FUNC(setArea);
    }, [], GAR_COOLDOWN] call CBA_fnc_waitAndExecute;
};  

nil