/*
Author:
Nicholas Clark (SENSEI)

Description:
Load a setting from paramsArray

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

{
    private _name = configName ((missionConfigFile >> "Params") select _ForEachIndex);
    private _value = paramsArray select _ForEachIndex;
    private _typeName = getText (missionConfigFile >> "Params" >> _name >> "typeName");
    private _set = getNumber (missionConfigFile >> "Params" >> _name >> QUOTE(DOUBLES(PREFIX,setting)));

    if (_set > 0) then {
        _value = [_name,_typeName,_value] call FUNC(setSettingsValue);
        missionNamespace setVariable [_name,_value,true];
        INFO_3("Include mission param %1 (%2): %3", _name,_typeName,_value);
    };
} forEach paramsArray;
