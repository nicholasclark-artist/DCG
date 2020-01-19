/*
Author:
Nicholas Clark (SENSEI)

Description:

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

// phase 1: locate primary intel
[
    {(GVAR(intelPrimary) getVariable [QGVAR(status),-1]) isEqualTo 0},
    {
        // phase 2: complete garrison task

        // set new AO

        // set and spawn garrison in AO

        // set tasks
        
        // tally number of secondary intels found 

        // reveal comms array and enemy patrols for each secondary intel

        
    },
    []
] call CBA_fnc_waitUntilAndExecute;


nil