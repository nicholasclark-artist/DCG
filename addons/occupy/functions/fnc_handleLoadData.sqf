/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

if !(_data isEqualTo []) then {
    [_data] call FUNC(findLocation);
} else {
    [] call FUNC(findLocation);
};

nil