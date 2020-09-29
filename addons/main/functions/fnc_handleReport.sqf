/*
Author:
Nicholas Clark (SENSEI)

Description:
handle scenario reports

Arguments:
0: player <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define TITLE_SIZE CBAN_TITLE_SIZE * 0.8
#define BODY_SIZE CBAN_BODY_SIZE * 0.9

if (!isServer) exitWith {};

params [
    ["_player",objNull,[objNull]]
];

private _text = [["Scenario Report",CBAN_TITLE_SIZE,CBAN_TITLE_COLOR]];
private _textAddon = [];

// format date
private _date = date;
private _month = switch (_date select 1) do {
    case 1: {"Janurary"};
    case 2: {"Feburary"};
    case 3: {"March"};
    case 4: {"April"};
    case 5: {"May"};
    case 6: {"June"};
    case 7: {"July"};
    case 8: {"August"};
    case 9: {"September"};
    case 10: {"October"};
    case 11: {"November"};
    case 12: {"December"};
    default {""};
};

private _date = [_month,_date select 2,_date select 0,[daytime,"HH:MM"] call BIS_fnc_timeToString] joinString ", ";

_text append [[_date,BODY_SIZE,CBAN_BODY_COLOR],""];

// format addon text
if (CHECK_ADDON_2(weather)) then {
    _textAddon = [
        ["Weather",TITLE_SIZE,CBAN_TITLE_COLOR],
        [format ["Temperature: %1°C high, %2°C low",EGVAR(weather,temperatureDay),EGVAR(weather,temperatureNight)],BODY_SIZE,CBAN_BODY_COLOR],
        [format ["Precipitation: %1%2",parseNumber (EGVAR(weather,precipitation) toFixed 2) * 100,"%"],BODY_SIZE,CBAN_BODY_COLOR],
        ""
    ];

    _text append _textAddon;
};

if (CHECK_ADDON_2(transport)) then {
    // @todo use transport status macros
    private _status = switch (EGVAR(transport,status)) do {
        case "READY": {"Ready"};
        case "NOT READY": {"Active"};
        case "WAITING": {"Standby"};
        default {""};
    };

    _textAddon = [
        ["Transport",TITLE_SIZE,CBAN_TITLE_COLOR],
        [format ["Active transports: %1/%2",EGVAR(transport,count),EGVAR(transport,limit)],BODY_SIZE,CBAN_BODY_COLOR],
        [format ["Request status: %1",_status],BODY_SIZE,CBAN_BODY_COLOR],
        ""
    ];

    _text append _textAddon;
};

if (CHECK_ADDON_2(approval)) then {
    scopeName "approval";

    private _position = getPosASL _player;
    private _region = [_position] call EFUNC(approval,getRegion);

    // @todo add unknown region hint on exit
    if (isNull _region) exitWith {nil};

    private _posRegion = _region getVariable [QGVAR(positionASL),DEFAULT_POS];
    private _altitude = round (_posRegion select 2);
    private _distance = round (_posRegion vectorDistance _position);
    private _name = _region getVariable [QGVAR(name),""];
    private _type = _region getVariable [QGVAR(type),""];
    private _id = "";

    // format type
    _type = switch (toLower _type) do {
        case "namevillage": {"Small"};
        case "namecity": {"Medium"};
        case "namecitycapital": {"Large"};
        default {"Unknown"};
    };

    // get id
    [GVAR(locations),{
        private _nameValue = _value getVariable [QGVAR(name),""];
        if (COMPARE_STR(_nameValue,_name)) then {
            _id = str (_forEachIndex + 1); // @todo change method, id relies on CBA_fnc_hashEachPair internal forEach loop
            breakTo "approval";
        };
    }] call CBA_fnc_hashEachPair;

    _textAddon = [
        [format ["Region %1",_id],TITLE_SIZE,CBAN_TITLE_COLOR],
        ["Open map to view region border",CBAN_SUB_SIZE,CBAN_SUB_COLOR],
        "",
        [format ["Region approval: %1/%2",(_region getVariable [QEGVAR(approval,value),0]) toFixed 2,AP_MAX],BODY_SIZE,CBAN_BODY_COLOR],
        [format ["Nearest settlement: %1",_name],BODY_SIZE,CBAN_BODY_COLOR],
        [format ["Settlement size: %1",_type],BODY_SIZE,CBAN_BODY_COLOR],
        [format ["Distance to settlement: %1m",_distance],BODY_SIZE,CBAN_BODY_COLOR],
        [format ["Settlement altitude: %1m",_altitude],BODY_SIZE,CBAN_BODY_COLOR],
        ""
    ];

    _text append _textAddon;

    [
        [_region getVariable [QGVAR(polygon),DEFAULT_POLYGON],_region getVariable [QEGVAR(approval,color),DEFAULT_COLOR]],
        {
            params ["_polygon","_color"];

            // draw approval region
            private _statement = format ["(_this select 0) drawPolygon [%1,%2];",_polygon,_color];
            private _map = findDisplay 12 displayCtrl 51;
            private _id = _map ctrlAddEventHandler ["Draw",_statement];

            GVAR(regionMapID) = _id;

            [
                {!(GVAR(regionMapID) isEqualTo (_this select 1)) || {CBA_missionTime > ((_this select 2) + cba_ui_notifyLifetime)}},
                {
                    (_this select 0) ctrlRemoveEventHandler ["Draw",(_this select 1)];
                },
                [_map,_id,CBA_missionTime]
            ] call CBA_fnc_waitUntilAndExecute;
        }
    ] remoteExecCall [QUOTE(call),_player,false];
};

// send to player
[_text,{_this call FUNC(notify)}] remoteExecCall [QUOTE(call),_player,false];