/*
Author:
Nicholas Clark (SENSEI), Larrow

Description:
get transport children for interaction menu

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define TR_LISTSIZE 3

private _actions = [];
private _fnc_getCargo = {
    private ["_baseCfg","_numCargo"];
    params ["_vehType"];

    _baseCfg = configFile >> "CfgVehicles" >> _vehType;

    _numCargo = count ("
        if (isText(_x >> 'proxyType') && {getText(_x >> 'proxyType') isEqualTo 'CPCargo'}) then {
            true
        };
    "configClasses (_baseCfg >> "Turrets")) + getNumber (_baseCfg >> "transportSoldier");

    _numCargo
};

_pool = [EGVAR(main,playerSide),2] call EFUNC(main,getPool);

{
    if (count _actions isEqualTo TR_LISTSIZE) exitWith {
        LOG_1("Exceeded limit (%1) for transport list",TR_LISTSIZE);
    };

    if (_x isKindOf "Helicopter" && {([_x] call _fnc_getCargo) >= GVAR(cargoThreshold)}) then {
        _displayName = format ["Call in %1",getText (configfile >> "CfgVehicles" >> _x >> "displayName")];
        if (CHECK_ADDON_1(ace_interact_menu)) then {
            _action = [_x, _displayName, "", {[_this select 2] call FUNC(request)}, {true}, {}, _x] call ace_interact_menu_fnc_createAction;
            _actions pushBack [_action, [], player];
        } else {
            _action = player addAction [_displayName, {[_this select 3] call FUNC(request)}, _x, 0, false, true, "", QUOTE(call FUNC(canCallTransport))];
            _actions pushBack _action;
        };
    };
} forEach _pool;

_actions
