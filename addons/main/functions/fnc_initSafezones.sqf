/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize safezone triggers,run from EDEN attributes

Arguments:
0: editor placed marker <STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (is3DEN || {!isServer} || {!GVAR(safezoneEnable)}) exitWith {};

// run after settings init
if (!GVAR(settingsInitFinished)) exitWith {
    GVAR(runAtSettingsInitialized) pushBack [FUNC(initSafezones),_this];
};

// exit if main addon disabled
if !(GVAR(enable)) exitWith {};

params ["_marker"];

// handle markers with bad shapes
if !(toUpper markerShape _marker in ["RECTANGLE","ELLIPSE"]) then {
    _marker setMarkerShape "ELLIPSE";
};

_marker setMarkerColor ([GVAR(playerSide),true] call BIS_fnc_sideColor);

_trg = createTrigger ["EmptyDetector",getMarkerPos _marker];

private _act = format ["
    diag_log '%1 activated';
    {
        if (!isPlayer _x && {!(_x getVariable ['%2',false])}) then {
            _x call CBA_fnc_deleteEntity;
        };
    } forEach thisList;
",_trg,QGVAR(safezoneKeepEntity)]; // @todo add keep functionality to documentation

private _deact = format [" diag_log '%1 deactivated';",_trg];

_trg setTriggerActivation [format["%1",GVAR(enemySide)],"PRESENT",true];
_trg setTriggerStatements ["this",_act,_deact];
_trg setTriggerArea [(getMarkerSize _marker) select 0,(getMarkerSize _marker) select 1,markerDir _marker,COMPARE_STR(markerShape _marker,"RECTANGLE")];

GVAR(safezoneTriggers) pushBack _trg;
GVAR(safezoneMarkers) pushBack _marker;

// refresh marker display setting
["cba_settings_refreshSetting", QGVAR(safezoneMarkersDisplay)] call CBA_fnc_localEvent;

TRACE_1("",GVAR(safezoneTriggers));

nil