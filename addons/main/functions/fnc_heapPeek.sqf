/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-14
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.
    
    Description: Returns the node on top of the heap in format ([key, item])
*/
#include "script_component.hpp"

private _return = [];
if(_this isEqualType [] && !(_this isEqualTo [])) then {
    _return = +(_this#0);
};
_return