/*
Author:
Nicholas Clark (SENSEI)

Description:
set civilian panic state

Arguments:
0: unit <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define PANIC_ANIMS ["ApanPknlMstpSnonWnonDnon_G01","ApanPknlMstpSnonWnonDnon_G02","ApanPknlMstpSnonWnonDnon_G03"]
#define PANIC_WAIT 60 + random 200

params ["_unit","_state"];

if !(local _unit) exitWith {
    WARNING_1("%1 not local",_unit);
};

switch (_state) do {
    case 0: { // stop panic
        _unit setVariable [QGVAR(panic),false];
        _unit setVariable [QGVAR(patrol),true];
        _unit enableAI "ANIM";
        [_unit,"",2] call EFUNC(main,setAnim);
        _unit forceSpeed (_unit getSpeed "SLOW");
    };
    case 1: { // panic in place
        _unit setVariable [QGVAR(panic),true];

        CIV_MOVETO_COMPLETE(_unit);

        if !(_unit getVariable [QGVAR(patrol),false]) then {
            [_unit] call EFUNC(main,removeAmbientAnim);
        };
        
        [_unit,selectRandom PANIC_ANIMS,2] call EFUNC(main,setAnim);
        _unit disableAI "ANIM";

        // stop panicking after some time
        [
            {
                if (alive (_this select 0)) then {
                    [QGVAR(panic),[_this select 0,0]] call CBA_fnc_localEvent;
                };  
            },
            [_unit],
            PANIC_WAIT
        ] call CBA_fnc_waitandExecute;
    };
    default {WARNING("unknown state")};
};

nil