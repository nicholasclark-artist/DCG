/*
Author:
Nicholas Clark (SENSEI)

Description:
handle approval hints

Arguments:
0: player to send hint to <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define MAP_DRAWTIME 30
#define AP_HINT_TITLE(NAME) format ["<t size='1.4' align='center'>Region %1</t><br/>",NAME]
#define AP_HINT_SUBTITLE "<t size='0.94' align='center'>Open map to view region border</t><br/><br/>"
#define AP_HINT_BODY(NAME,TYPE,ALT,DIST) format ["<t align='center'>Nearest settlement: %1 <br/>Settlement type: %2 <br/>Settlement altitude: %3m <br/>Distance to settlement: %4m</t><br/>",NAME,TYPE,ALT,DIST]

params [
    ["_player",objNull,[objNull]]
];

private _position = getPosASL _player;
private _region = [_position] call FUNC(getRegion);

// @todo add unknown region hint on exit
if (isNull _region) exitWith {nil};

private _posRegion = _region getVariable [QEGVAR(main,positionASL),[0,0,0]];
private _altitude = round (_posRegion select 2);
private _distance = round (_posRegion vectorDistance _position); 
private _name = _region getVariable [QEGVAR(main,name),""];
private _type = _region getVariable [QEGVAR(main,type),""];

_type = switch (toLower _type) do {
    case "namevillage": {"Village"};
    case "namecity": {"City"};
    case "namecitycapital": {"Capital"};
    default {"Unknown"};
};

private _text = [AP_HINT_TITLE(mapGridPosition (_posRegion)),AP_HINT_SUBTITLE,AP_HINT_BODY(_name,_type,_altitude,_distance)] joinString "";

[
    [_region getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON],_region getVariable [QGVAR(color),DEFAULT_COLOR],_text],
    {
        params ["_polygon","_color","_text"];

        private _statement = format ["(_this select 0) drawPolygon [%1,%2];",_polygon,_color];
        private _map = findDisplay 12 displayCtrl 51;
        private _id = _map ctrlAddEventHandler ["Draw",_statement];

        GVAR(regionMapID) = _id;

        // convert to text on client to avoid SimpleSerialization warning
        _text = parseText _text;
        [_text,true] call EFUNC(main,displayText);

        [
            {!(GVAR(regionMapID) isEqualTo (_this select 1)) || {CBA_missionTime > ((_this select 2) + MAP_DRAWTIME)}},
            {
                // only overwrite hint if client has not requested another hint
                if (GVAR(regionMapID) isEqualTo (_this select 1)) then {
                    ["",false] call EFUNC(main,displayText);
                };

                (_this select 0) ctrlRemoveEventHandler ["Draw",(_this select 1)];
            },
            [_map,_id,CBA_missionTime]
        ] call CBA_fnc_waitUntilAndExecute; 
    }
] remoteExecCall [QUOTE(call),owner _player,false];

nil
