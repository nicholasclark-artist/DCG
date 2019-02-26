/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Percolate a node up the tree (towards the root) to its correct height
*/
#include "script_component.hpp"

params ["_heap", "_i"];
private _parent = HEAP_PARENT(_i);
while {_parent >= 0} do {
    private _keyChild = HEAP_KEY(_heap#_i);
    private _keyParent = HEAP_KEY(_heap#_parent);
    if( HEAP_COMPARE(_keyChild,_keyParent) ) then {
        [_heap, _i, _parent] call FUNC(heapSwap);
    };
    _i = _parent;
    _parent = HEAP_PARENT(_i);
};

/* TODO Test this version later
params ["_heap", "_i"];
private _parent = HEAP_PARENT(_i);
while {_parent >= 0} do {
    private _keyChild = HEAP_KEY(_heap#_i);
    private _keyParent = HEAP_KEY(_heap#_parent);
    if( HEAP_COMPARE(_keyChild,_keyParent) ) then {
        [_heap, _i, _parent] call FUNC(heapSwap);
        _i = _parent;
        _parent = HEAP_PARENT(_i);
    } else {
        _parent = -1;
    };
};
*/