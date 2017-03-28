/*
Author:
Nicholas Clark (SENSEI)

Description:
handle safezone

Arguments:


Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (GVAR(baseSafezone)) then {
    {
    	if (side _x isEqualTo GVAR(enemySide) && {!isPlayer _x}) then {
    		deleteVehicle (vehicle _x);
    		deleteVehicle _x;
    	};
    	false
    } count (locationPosition GVAR(baseLocation) nearEntities [["Man","LandVehicle","Ship","Air"], GVAR(baseRadius)]);
};
