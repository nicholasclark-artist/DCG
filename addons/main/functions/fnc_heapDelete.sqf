/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Deletes an item from the heap, which item is determined by the key.
*/
#include "script_component.hpp"

params [
    "_heap", 
    "_key"
];

//Find the key through breadth first traversal
private _visitQueue = [0];
private _found = -1;
while {count _visitQueue > 0 && _found < 0} do {
    private _i = _visitQueue deleteAt 0;
    private _elem = _heap#_i;
    private _elemKey = HEAP_KEY(_elem);
    
    if(_key == _elemKey) then {
        _found = _i;
    } else {
        private _leftChild = HEAP_LEFT(_i);
        if(_leftChild <= HEAP_LAST(_heap)) then {
            _visitQueue pushBack _leftChild;
        };
        
        private _rightChild = HEAP_RIGHT(_i);
        if(_rightChild <= HEAP_LAST(_heap)) then {
            _visitQueue pushBack _rightChild;
        };
    };
};

//If found delete it
private _delete = _found >= 0;
if(_delete) then {
    _heap#_found set [HEAP_NODE_KEY, HEAP_G_TOP_KEY];
    [_heap, _found] call FUNC(heapPercUp);
    _heap call FUNC(heapPop);
};

_delete