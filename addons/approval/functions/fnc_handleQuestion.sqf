/*
Author:
Nicholas Clark (SENSEI)

Description:
question unit

Arguments:
0: player <OBJECT>
1: unit to question <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define COOLDOWN 300
#define SEND_MSG(MSG) [MSG] remoteExecCall [QEFUNC(main,displayText), _player, false]

params [
    ["_player",objNull,[objNull]],
    ["_unit",objNull,[objNull]]
];

if (diag_tickTime < (_unit getVariable [QGVAR(questioned),COOLDOWN * -1]) + COOLDOWN) exitWith {
    _text = [
        format ["%1 was questioned recently.",name _unit],
        format ["You questioned %1 not too long ago.",name _unit],
        format ["%1 already spoke to you.",name _unit]
    ];
    SEND_MSG(selectRandom _text);
};

_unit setVariable [QGVAR(questioned), diag_tickTime, true];

// @todo differentiate a civilian not having info and an unwillingness to talk
private _text = [
    format ["%1 doesn't have any relevant information.",name _unit],
    format ["%1 doesn't know anything.",name _unit],
    format ["%1 isn't interested in talking right now.",name _unit]
];

private _value = AP_CONVERT1(getpos _player);

// add bonus if player weapon lowered
if (weaponLowered _player) then {
    _value = _value + 0.1;
    TRACE_1("weapon lowered bonus",_value);
};

if (PROBABILITY(_value)) then {
    private _type = [0, floor random 2] select (CHECK_ADDON_2(ied));

    if (_type isEqualTo 0) exitWith {
        _near = _unit nearEntities [["CAManBase", "LandVehicle", "Ship", "Air"], 1200];
        _near = _near select {!(side _x isEqualTo EGVAR(main,playerSide)) && {!(side _x isEqualTo CIVILIAN)}};

        if (_near isEqualTo []) exitWith {
            SEND_MSG(selectRandom _text);
        };

        private _area = nearestLocations [getposATL (selectRandom _near), ["NameCityCapital","NameCity","NameVillage"], 1000];

        if (_area isEqualTo []) exitWith {
            SEND_MSG(selectRandom _text);
        };

        _text = [
            format ["%1 saw soldiers around %2 not too long ago.",name _unit,text (_area select 0)],
            format ["%1 heard about soldiers moving through %2.",name _unit,text (_area select 0)]
        ];

        SEND_MSG(selectRandom _text);
    };

    if (_type isEqualTo 1) exitWith {
        {
            if (CHECK_VECTORDIST(getPosASL _x,getPosASL _unit,1200) && {!(_x getVariable [QGVAR(iedMarked),false])}) exitWith {
                _text = [
                    format ["%1 spotted a suspicious device alongside the road a few hours ago. He marked it on your map.",name _unit],
                    format ["%1 saw a man burying something in the road a while ago. He marked the position on your map.",name _unit]
                ];

                _x setVariable [QGVAR(iedMarked),true];

                _mrk = createMarker [format ["%1_%2",QUOTE(ADDON),diag_tickTime], getpos _x]; 
                _mrk setMarkerType "hd_warning";
                _mrk setMarkerSize [0.75,0.75];
                _mrk setMarkerColor "ColorRed";
            };
        } forEach (EGVAR(ied,list));

        SEND_MSG(selectRandom _text);
    };
} else {
    SEND_MSG(selectRandom _text);
};

nil