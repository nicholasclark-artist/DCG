/*
Author:
Nicholas Clark (SENSEI)

Description:
setup eventhandlers on curator unit

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

INFO_1("Running curator eventhandlers on %1.",getAssignedCuratorUnit GVAR(curator));

// save event code to variable, give eventhandler less code to compile, https://feedback.bistudio.com/T123355
GVAR(curatorRegistered) = {
    _costs = [];
    {
        _side = getNumber (configFile >> "CfgVehicles" >> _x >> "side");
        _cost = [_x] call FUNC(getCuratorCost);

        if (!(_cost isEqualTo 0) && {_side isEqualTo ([EGVAR(main,playerSide)] call BIS_fnc_sideID) || _side isEqualTo 3}) then {
            _cost = [true,_cost];
        } else {
            _cost = [false,_cost];
        };

        _costs pushBack _cost;
    } forEach (_this select 1);

    _costs
};

GVAR(curatorPlaced) = {
    if (typeOf (_this select 1) in FOB_MED) then {
        (_this select 1) setVariable ["ace_medical_isMedicalFacility",true,true];
    };

    if (EGVAR(approval,enable) isEqualTo 1) then {
        _cost = [typeOf (_this select 1)] call FUNC(getCuratorCost);
        _cost = _cost*FOB_COST_MULTIPIER;

        [QEGVAR(approval,add), [getPosASL (_this select 1), _cost]] call CBA_fnc_serverEvent;
    };
};

GVAR(curatorDeleted) = {
    if (EGVAR(approval,enable) isEqualTo 1) then {
        _cost = [typeOf (_this select 1)] call FUNC(getCuratorCost);
        _cost = _cost*FOB_COST_MULTIPIER;

        [QEGVAR(approval,add), [getPosASL (_this select 1),_cost * -1]] call CBA_fnc_serverEvent;
    };
};

GVAR(curator) removeAllEventHandlers "CuratorObjectRegistered";
GVAR(curator) addEventHandler ["CuratorObjectRegistered",{call GVAR(curatorRegistered)}];

GVAR(curator) removeAllEventHandlers "CuratorObjectPlaced";
GVAR(curator) addEventHandler ["CuratorObjectPlaced",{call GVAR(curatorPlaced)}];

GVAR(curator) removeAllEventHandlers "CuratorObjectDeleted";
GVAR(curator) addEventHandler ["CuratorObjectDeleted",{call GVAR(curatorDeleted)}];

nil