/*
Author:
bux578, commy2, Nicholas Clark (SENSEI)

Description:
restore player loadout

Arguments:
0: player <OBJECT>
1: saved gear <ARRAY>
2: saved weapon <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_unit", "_allGear", "_activeWeaponAndMuzzle"];

// restore all gear
if (!isNil "_allGear") then {
    _unit setUnitLoadout _allGear;
};

// restore the last active weapon, muzzle and weaponMode
if (!isNil "_activeWeaponAndMuzzle") then {
    // @todo, replace this with CBA_fnc_selectWeapon after next CBA update
    _activeWeaponAndMuzzle params ["_activeWeapon", "_activeMuzzle", "_activeWeaponMode"];

    if (
        (_activeMuzzle != "") &&
        {_activeMuzzle != _activeWeapon} &&
        {_activeMuzzle in getArray (configFile >> "CfgWeapons" >> _activeWeapon >> "muzzles")}
    ) then {
        _unit selectWeapon _activeMuzzle;
    } else {
        if (_activeWeapon != "") then {
            _unit selectWeapon _activeWeapon;
        };
    };

    if (currentWeapon _unit != "") then {
        private _index = 0;

        while {
            _index < 100 && {currentWeaponMode _unit != _activeWeaponMode}
        } do {
            _unit action ["SwitchWeapon", _unit, _unit, _index];
            _index = _index + 1;
        };
    };
};