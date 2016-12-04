/*
Author:
Nicholas Clark (SENSEI)

Description:
init FOB curator

Arguments:

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(side) = createCenter sideLogic;
GVAR(group) = createGroup GVAR(side);

GVAR(curator) = GVAR(group) createUnit ["ModuleCurator_F",[0,0,0], [], 0, "FORM"];
GVAR(curator) setVariable ["showNotification", false, true];
GVAR(curator) setVariable ["birdType", "", true];
GVAR(curator) setVariable ["Owner", "", true];
GVAR(curator) setVariable ["Addons", 3, true];
GVAR(curator) setVariable ["Forced", 0, true];

publicVariable QGVAR(curator);

// edge case, curator may be deleted some time after init, killed eventhandler is a workaround
GVAR(curator) addEventHandler ["killed", {
    INFO_1("Curator killed: %1",_this);
    call FUNC(init);
}];

INFO_1("Curator list %1",allCurators);
