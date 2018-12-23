/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize safezone triggers

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

// @todo add type object support

_act = "
    {
    	if !(isPlayer _x) then {
			_x call CBA_fnc_deleteEntity;
    	};
    	false
    } forEach thisList;
";

_deact = "";

_trg = createTrigger ["EmptyDetector", getMarkerPos _this];
_trg setTriggerArea [(getMarkerSize _this) select 0, (getMarkerSize _this) select 0, 0, false];
_trg setTriggerActivation [FORMAT_1("%1",EGVAR(main,enemySide)), "PRESENT", true];
_trg setTriggerStatements ["this", _act, _deact]; 

GVAR(list) pushBack _trg;

nil