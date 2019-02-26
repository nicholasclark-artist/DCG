/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Percolate an node down the tree to its correct height
*/
#include "script_component.hpp"

params ["_heap", "_i"];
private _key = HEAP_KEY(_heap#_i);
private _left = HEAP_LEFT(_i);
private _keyLeft = if(_left < count _heap) then { HEAP_KEY(_heap#_left) } else { HEAP_UNDEFINED_KEY };
private _right = HEAP_RIGHT(_i);
private _keyRight = if(_right < count _heap) then { HEAP_KEY(_heap#_right) } else { HEAP_UNDEFINED_KEY };

if(HEAP_COMPARE(_keyLeft,_key) || HEAP_COMPARE(_keyRight,_key)) then {
    private _swap = [_left,_right] select HEAP_COMPARE(_keyRight,_keyLeft);
    [_heap, _i, _swap] call FUNC(heapSwap);
    [_heap, _swap] call FUNC(heapPercDown);
};
