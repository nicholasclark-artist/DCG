/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define ACE_TYPES ["IEDUrbanBig_Remote_Mag","IEDUrbanSmall_Remote_Mag"]
#define VANILLA_TYPES ["IEDUrbanBig_F","IEDUrbanSmall_F"]

POSTINIT;

EGVAR(main,grid) call FUNC(init);

if !(CHECK_ADDON_1(ace_explosives)) then {
    [FUNC(handleIED), 1, []] call CBA_fnc_addPerFrameHandler;
};