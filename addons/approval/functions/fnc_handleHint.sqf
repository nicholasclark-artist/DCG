/*
Author:
Nicholas Clark (SENSEI)

Description:
handle approval hints

Arguments:
0: player to send hint to <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_player",objNull,[objNull]]
];

private _region = [getPos _player] call FUNC(getRegion);
private _value = [getpos _player] call FUNC(getValue);
private _safety = (1 - (AV_CHANCE(getPos _player))) * 100;

_value = parseNumber (_value toFixed 1);
_safety = parseNumber (_safety toFixed 1);

private _hint = format ["
    %4 \n \n
    Region Approval: %1/%3 \n
    Region Safety: %2/%3 \n
",_value,_safety,AV_MAX,toUpper COMPONENT_NAME];

if !(isNil "_region") then {
    [
        [getPos _region,size _region,_hint],
        {
            params ["_position","_size","_hint"];

            [_hint,true] call EFUNC(main,displayText);

            private _mrk = createMarkerLocal [QUOTE(DOUBLES(ADDON,hintMarker)),_position];
            _mrk setMarkerBrushLocal "SolidBorder";
            _mrk setMarkerColorLocal "ColorBlack";
            _mrk setMarkerSizeLocal _size;
            _mrk setMarkerShapeLocal "RECTANGLE";
            _mrk setMarkerAlphaLocal 1;

            if (CHECK_MARKER(_mrk)) then {
                [{
                    params ["_args","_idPFH"];
                    _args params ["_mrk"];
                    if (markerAlpha _mrk < 0.01) exitWith {
                        [_idPFH] call CBA_fnc_removePerFrameHandler;
                        deleteMarker _mrk;
                    };
                    _mrk setMarkerAlphaLocal (markerAlpha _mrk - .005);
                }, 0, [_mrk]] call CBA_fnc_addPerFrameHandler;
            };
        }
    ] remoteExecCall [QUOTE(BIS_fnc_call), owner _player, false];
};
