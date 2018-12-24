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

private ["_act", "_deact"];

_act = "
    {
    	if !(isPlayer _x) then {
			_x call CBA_fnc_deleteEntity;
    	};
    } forEach thisList;
";

_deact = "";

_trg = createTrigger ["EmptyDetector", getMarkerPos _this];
_trg setTriggerArea [(getMarkerSize _this) select 0, (getMarkerSize _this) select 0, 0, false];
_trg setTriggerActivation [FORMAT_1("%1",EGVAR(main,enemySide)), "PRESENT", true];
_trg setTriggerStatements ["this", _act, _deact]; 

_marker = createMarker [FORMAT_2("%1_marker_%2",QUOTE(ADDON),count GVAR(markers)), getMarkerPos _this]; 
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [(getMarkerSize _this) select 0, (getMarkerSize _this) select 0];
_marker setMarkerBrush "SolidBorder";
_marker setMarkerColor ([EGVAR(main,playerSide),true] call BIS_fnc_sideColor); 
_marker setMarkerAlpha 0;

GVAR(list) pushBack _trg;
GVAR(markers) pushBack _marker;

deleteMarker _this;

nil