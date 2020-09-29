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
#define SEND_MSG(NAME,MSG) [[[NAME,":"] joinString "",CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],[MSG,CBAN_BODY_SIZE,CBAN_BODY_COLOR],true] remoteExecCall [QEFUNC(main,notify),_player,false]

params [
    ["_player",objNull,[objNull]],
    ["_unit",objNull,[objNull]]
];

if (diag_tickTime < (_unit getVariable [QGVAR(questioned),COOLDOWN * -1]) + COOLDOWN) exitWith {
    _text = [
        "I don't have anything else to say.",
        "I already spoke to you.",
        "I'm done talking."
    ];
    SEND_MSG(name _unit,selectRandom _text);
};

_unit setVariable [QGVAR(questioned),diag_tickTime,true];

// @todo differentiate a civilian not having info and an unwillingness to talk
private _text = [
    "I don't have any relevant information.",
    "I don't know anything.",
    "I can't talk right now."
];

private _value = AP_CONVERT1(getpos _player);

// add bonus if player weapon lowered
if (weaponLowered _player) then {
    _value = _value + 0.1;
    TRACE_1("weapon lowered bonus",_value);
};

if (PROBABILITY(_value)) then {
    private _type = [0,floor random 2] select (CHECK_ADDON_2(ied));

    if (_type isEqualTo 0) exitWith {
        _near = _unit nearEntities [["CAManBase","LandVehicle","Ship","Air"],1200];
        _near = _near select {!(side _x isEqualTo EGVAR(main,playerSide)) && {!(side _x isEqualTo CIVILIAN)}};

        if (_near isEqualTo []) exitWith {
            SEND_MSG(name _unit,selectRandom _text);
        };

        private _area = nearestLocations [getposATL (selectRandom _near),["NameCityCapital","NameCity","NameVillage"],1000];

        if (_area isEqualTo []) exitWith {
            SEND_MSG(name _unit,selectRandom _text);
        };

        _text = [
            format ["I saw soldiers around %2 not too long ago.",text (_area select 0)],
            format ["I heard about soldiers moving through %2.",name _unit,text (_area select 0)]
        ];

        SEND_MSG(name _unit,selectRandom _text);
    };

    if (_type isEqualTo 1) exitWith {
        {
            if (CHECK_VECTORDIST(getPosASL _x,getPosASL _unit,1200) && {!(_x getVariable [QGVAR(iedMarked),false])}) exitWith {
                _text = [
                    "I saw something buried alongside the road a few hours ago. I'll point it out on your map.",
                    "I saw a man burying something in the road a while ago. I'll show you the location on your map."
                ];

                _x setVariable [QGVAR(iedMarked),true];

                _mrk = createMarker [format ["%1_%2",QUOTE(ADDON),diag_tickTime],getpos _x];
                _mrk setMarkerType "hd_warning";
                _mrk setMarkerSize [0.75,0.75];
                _mrk setMarkerColor "ColorRed";
            };
        } forEach (EGVAR(ied,list));

        SEND_MSG(name _unit,selectRandom _text);
    };
} else {
    SEND_MSG(name _unit,selectRandom _text);
};

nil