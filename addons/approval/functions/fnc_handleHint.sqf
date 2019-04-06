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
#define AP_HINT_SUBTITLE "<t size='0.94' align='center'>Open map to view region</t><br/><br/>"
#define AP_HINT_BODY(NAME,TYPE,ALT,DIST) format ["<t align='center'>Nearest settlement: %1 <br/>Settlement type: %2 <br/>Settlement altitude: %3m <br/>Distance to settlement: %4m</t><br/>",NAME,TYPE,ALT,DIST]

params [
    ["_player",objNull,[objNull]]
];

private _position = getPosATL _player;
private _region = [_position] call FUNC(getRegion);
private _name = _region select 0;
private _value = _region select 1;
private _altitude = round (_value select 0 select 2);
private _distance = round (_value select 0 distance2D _position);
private _type = ([EGVAR(main,locations),_name] call CBA_fnc_hashGet) select 2;

_type = switch (toLower _type) do {
    case "namevillage": {"Village"};
    case "namecity": {"City"};
    case "namecitycapital": {"Capital"};
    default {"Unknown"};
};

private _text = [AP_HINT_TITLE(mapGridPosition (_value select 0)),AP_HINT_SUBTITLE,AP_HINT_BODY(_name,_type,_altitude,_distance)] joinString "";

[
    [_value,_text],
    {
        params ["_value","_text"];
        
        private _statement = format ["(_this select 0) drawPolygon [%1,%2];",_value select 2,_value select 3];
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
] remoteExecCall [QUOTE(call), owner _player, false];

nil
