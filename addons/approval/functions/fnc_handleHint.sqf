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
#define SCOPE QGVAR(handleHint)

params [
    ["_player",objNull,[objNull]]
];

scopeName SCOPE;

private _position = getPosASL _player;
private _region = [_position] call FUNC(getRegion);

// @todo add unknown region hint on exit
if (isNull _region) exitWith {nil};

private _posRegion = _region getVariable [QEGVAR(main,positionASL),DEFAULT_POS];
private _altitude = round (_posRegion select 2);
private _distance = round (_posRegion vectorDistance _position);
private _name = _region getVariable [QEGVAR(main,name),""];
private _type = _region getVariable [QEGVAR(main,type),""];
private _id = "";

// format type
_type = switch (toLower _type) do {
    case "namevillage": {"Small"};
    case "namecity": {"Medium"};
    case "namecitycapital": {"Large"};
    default {"Unknown"};
};

// get id
[EGVAR(main,locations),{
    private _nameValue = _value getVariable [QEGVAR(main,name),""];
    if (COMPARE_STR(_nameValue,_name)) then {
        _id = str (_forEachIndex + 1); // @todo change method, id relies on CBA_fnc_hashEachPair internal forEach loop
        breakTo SCOPE;
    };
}] call CBA_fnc_hashEachPair;

private _text = [
    [COMPONENT_NAME,CBAN_TITLE_SIZE,CBAN_TITLE_COLOR],
    ["Open map to view region border",CBAN_SUB_SIZE,CBAN_SUB_COLOR],
    "",
    [format ["Region ID: %1",_id],CBAN_BODY_SIZE,CBAN_BODY_COLOR],
    [format ["Nearest settlement: %1",_name],CBAN_BODY_SIZE,CBAN_BODY_COLOR],
    [format ["Settlement size: %1",_type],CBAN_BODY_SIZE,CBAN_BODY_COLOR],
    [format ["Distance to settlement: %1m",_distance],CBAN_BODY_SIZE,CBAN_BODY_COLOR],
    [format ["Settlement altitude: %1m",_altitude],CBAN_BODY_SIZE,CBAN_BODY_COLOR],
    true
];

[
    [_region getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON],_region getVariable [QGVAR(color),DEFAULT_COLOR],_text],
    {
        params ["_polygon","_color","_text"];

        private _statement = format ["(_this select 0) drawPolygon [%1,%2];",_polygon,_color];
        private _map = findDisplay 12 displayCtrl 51;
        private _id = _map ctrlAddEventHandler ["Draw",_statement];

        GVAR(regionMapID) = _id;

        _text call EFUNC(main,notify);

        [
            {!(GVAR(regionMapID) isEqualTo (_this select 1)) || {CBA_missionTime > ((_this select 2) + cba_ui_notifyLifetime)}},
            {
                (_this select 0) ctrlRemoveEventHandler ["Draw",(_this select 1)];
            },
            [_map,_id,CBA_missionTime]
        ] call CBA_fnc_waitUntilAndExecute;
    }
] remoteExecCall [QUOTE(call),owner _player,false];

nil
