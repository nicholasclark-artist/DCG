/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Creates a new heap from a given array of arrays with the first element of each sub-array being a key (number).
    Example: 
        [[1, "world!"], [2, "there"], [3, "Hello"]] call FUNC(heapNew)
*/
#include "script_component.hpp"
private _return = [];
if(_this isEqualType []) then {
    private _heap = +_this;
    private _i = HEAP_LAST(_heap);
    while { _i >= 0 } do {
        [_heap, _i] call FUNC(heapPercDown);
        _i = _i - 1;
    };

    _return = _heap;
};
_return
