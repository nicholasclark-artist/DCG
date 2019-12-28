/*
Author:
Nicholas Clark (SENSEI)

Description:
get unique name

Arguments:

Return:
string
__________________________________________________________________*/
#include "script_component.hpp"

private ["_name"];

for "_i" from 0 to 99 do {
    _name = call EFUNC(main,getAlias);

    if !(_name in GVAR(aliasBlacklist)) exitWith {
        GVAR(aliasBlacklist) pushBack _name;
    };

    _name = "";
};

_name