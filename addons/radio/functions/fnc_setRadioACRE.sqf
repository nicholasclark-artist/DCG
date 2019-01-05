/*
Author:
Nicholas Clark (SENSEI)

Description:
assigns ACRE2 radio and channels

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _missing = [];
private _pairs = [];

{player removeItem _x} forEach (call acre_api_fnc_getCurrentRadioList);

{
    _x params ["_net","_class"];

    if ({COMPARE_STR(str player,_x)} count _net > 0) then { // check if player in comm net
        if (player canAdd _class) then {
            _channel = _forEachIndex + 1;
            player addItem _class;
            _pairs pushBack [_class,_channel]; // pushBack classname and channel pair
        } else {
            _missing pushBack _class;
        };
    };
} forEach [
    [GVAR(commNet01),GVAR(commNet01_ACRE)],
    [GVAR(commNet02),GVAR(commNet02_ACRE)],
    [GVAR(commNet03),GVAR(commNet03_ACRE)],
    [GVAR(commNet04),GVAR(commNet04_ACRE)],
    [GVAR(commNet05),GVAR(commNet05_ACRE)],
    [GVAR(commNet06),GVAR(commNet06_ACRE)]
];

LOG_1("ACRE2 inventory pairs: %1",_pairs);
LOG_1("ACRE2 missing classes: %1",_missing);

if !(_pairs isEqualTo []) then {
  [ // set channel after radio ID is added
      {[] call acre_api_fnc_isInitialized},
      {
      params ["_pairs"];

      {
        _id = _x;
        _class = [_id] call acre_api_fnc_getBaseRadio;

        _matches = _pairs select {COMPARE_STR(_x select 0,_class)}; // get all pairs that match current radio class

        if !(_matches isEqualTo []) then {
          _selected = _matches select 0; // get the first matching pair
          [_id, _selected select 1] call acre_api_fnc_setRadioChannel;
          _pairs deleteAt (_pairs find _selected); // remove pair from array after setting channel

          INFO_3("Assign ACRE radio: id: %1, base class: %2, channel: %3",_id,_class,_selected select 1);
        };
      } forEach ([] call acre_api_fnc_getCurrentRadioList);
      },
      [_pairs]
  ] call CBA_fnc_waitUntilAndExecute;
};

if !(_missing isEqualTo []) then {
    _missing = _missing apply {[configFile >> "cfgWeapons" >> _x] call BIS_fnc_displayName};
    _missing = _missing joinString ", ";
    [format ["Cannot add the following radios to your inventory: %1",_missing],true] call EFUNC(main,displayText);
};
