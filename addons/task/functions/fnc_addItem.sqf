/*
Author:
Nicholas Clark (SENSEI)

Description:
add task item to unit, returns container that holds item

Arguments:
0: object <OBJECT>
1: item classname <STRING>

Return:
object
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj",objNull,[objNull]],
    ["_class","",[""]]
];

private _uniform = uniformContainer _obj;
private _vest = vestContainer _obj;
private _backpack = backpackContainer _obj;

{
    if (!(isNull _x) && {_x canAdd [_class, 1]}) exitWith {
        _x addItemCargoGlobal [_class, 1];
        _x
    };
    WARNING_3("Cannot add %1 to %2 on %3",_class,_x,_obj);

    objNull
} forEach [_uniform, _vest, _backpack];
