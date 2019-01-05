/*
Author:
Nicholas Clark (SENSEI)

Description:
assigns TFAR radio and channels

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define ID_SLEEP 6

private _missing = [];
private _pairs = [];

{player unlinkItem _x} forEach (player call TFAR_fnc_radiosList);
{player removeItem _x} forEach (player call TFAR_fnc_radiosList);

{
    _x params ["_net","_class"];

    if ({COMPARE_STR(str player,_x)} count _net > 0) then { // check if player in comm net
        if !(_class isKindOf "Bag_Base") then {
            if (player canAdd _class) then {
                player addItem _class;
                // channels are zero based
                _pairs pushBack [_class,_forEachIndex]; // pushBack classname and channel pair
            } else {
                _missing pushBack _class;
            };
        } else {
        _bItems = backpackItems player;
        player addBackpack _class;

        {
            player addItemToBackpack _x;
            false
        } count _bItems;

        _pairs pushBack [_class,_forEachIndex]; // pushBack classname and channel pair
        };
    };
} forEach [
    [GVAR(commNet01),GVAR(commNet01_TFAR)],
    [GVAR(commNet02),GVAR(commNet02_TFAR)],
    [GVAR(commNet03),GVAR(commNet03_TFAR)],
    [GVAR(commNet04),GVAR(commNet04_TFAR)],
    [GVAR(commNet05),GVAR(commNet05_TFAR)],
    [GVAR(commNet06),GVAR(commNet06_TFAR)]
];

LOG_1("TFAR inventory pairs: %1",_pairs);
LOG_1("TFAR missing classes: %1",_missing);

// TFAR function that checks for ID radios, TFAR_fnc_requestRadios, uses waitUntil :(
// hacky fix, set channel after an amount of time and hopefully ID is added
[
    {
        params ["_pairs"];

        // set SW radios
        {
            _id = _x;
            _matches = _pairs select {[_x select 0,_id] call TFAR_fnc_isSameRadio}; // get all pairs that match current radio class

            if !(_matches isEqualTo []) then {
                _selected = _matches select 0; // get the first matching pair
                [_id, _selected select 1] call TFAR_fnc_setSwChannel;
                _pairs deleteAt (_pairs find _selected); // remove pair from array after setting channel
            };
        } forEach (player call TFAR_fnc_radiosList);

        // set LR radio
        {
            if (COMPARE_STR(backpack player,_x select 0)) exitWith {
            [(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _x select 1] call TFAR_fnc_setLrChannel;
            };
        } forEach _pairs;
    },
    [_pairs],
    ID_SLEEP
] call CBA_fnc_waitAndExecute;

if !(_missing isEqualTo []) then {
    _missing = _missing joinString ", ";
    [format ["Cannot add the following radios to your inventory: %1",_missing],true] call EFUNC(main,displayText);
};
