/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize safezone triggers, run from EDEN attributes

Arguments:
0: editor placed marker <STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (is3DEN || {!GVAR(safezoneEnable)}) exitWith {}; // only run in mission

params ["_marker"];

private _act = format ["
    {
        if (!isPlayer _x && {!(_x getVariable [%1, false])}) then {
            _x call CBA_fnc_deleteEntity;
        };
    } forEach thisList;
",QGVAR(safezoneKeepEntity)]; // @todo add keep functionality to documentation

// handle markers with bad shapes
if (!(COMPARE_STR(markerShape _marker,"RECTANGLE")) && {!(COMPARE_STR(markerShape _marker,"ELLIPSE"))}) then {
    _marker setMarkerShape "ELLIPSE";
};

_marker setMarkerColor ([GVAR(playerSide),true] call BIS_fnc_sideColor); 
_marker setMarkerAlpha 0;

_trg = createTrigger ["EmptyDetector", getMarkerPos _marker];
_trg setTriggerActivation [format["%1",GVAR(enemySide)], "PRESENT", true];
_trg setTriggerStatements ["this", _act, ""];  
_trg setTriggerArea [(getMarkerSize _marker) select 0, (getMarkerSize _marker) select 1, markerDir _marker, COMPARE_STR(markerShape _marker,"RECTANGLE")];

GVAR(safezoneTriggers) pushBack _trg;
GVAR(safezoneMarkers) pushBack _marker;

nil