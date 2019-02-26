/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Pops the top item of the heap and returns it
*/
#include "script_component.hpp"

private _return = [];
if(_this isEqualType [] && !(_this isEqualTo [])) then {
    private _heap = _this;
    _return = (_heap#0);

    private _last = HEAP_LAST(_heap);
    if(_last == 0) then {
        _heap deleteAt _last;
    } else {
        _heap set [0, _heap deleteAt _last];
        [_heap, 0] call FUNC(heapPercDown);
    };
};
_return