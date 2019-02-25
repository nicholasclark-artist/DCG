/*
Author:
Nicholas Clark (SENSEI)

Description:
add recon UAV to FOB

Arguments:
0: to add or remove recon <BOOL>
1: position to add recon <ARRAY>
2: side of recon UAV <SIDE>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_ifRecon",true],
    ["_position",[0,0,0]],
    ["_side",EGVAR(main,playerSide)]
];

if (_ifRecon) then {
    private _type = call {
        if (_side isEqualTo WEST) exitWith {"B_UAV_02_F"};
        if (_side isEqualTo EAST) exitWith {"O_UAV_02_F"};
        if (_side isEqualTo INDEPENDENT) exitWith {"I_UAV_02_F"};
    };

    GVAR(uav) = createVehicle [_type, _position, [], 0, "FLY"];
    publicVariable QGVAR(uav);
    createVehicleCrew GVAR(uav);
    GVAR(uav) allowDamage false;
    GVAR(uav) setCaptive true;

    {
        _x setCaptive true;
        _x setBehaviour "CARELESS"; // should fix uav ai firing on enemies 
    } forEach crew GVAR(uav);

    GVAR(uav) lockDriver true;
    GVAR(uav) flyInHeight 200;
    
    GVAR(uav) addEventHandler ["Fuel",{
        if !(_this select 1) then {(_this select 0) setFuel 1};
    }];

    private _wp = group GVAR(uav) addWaypoint [_position, 0];
    _wp setWaypointType "LOITER";
    _wp setWaypointLoiterType "CIRCLE_L";
    _wp setWaypointLoiterRadius (GVAR(range)*1.5);
} else {
    GVAR(uav) call CBA_fnc_deleteEntity;
};
