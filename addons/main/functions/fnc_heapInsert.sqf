/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Insert an item into the heap 
*/
#include "script_component.hpp"

params [
    ["_heap", [], [[]]],
    ["_key", -1],
    "_value"
];

private _last = _heap pushBack [_key, _value];

[_heap, _last] call FUNC(heapPercUp);