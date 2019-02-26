/*
Author:
Nicholas Clark (SENSEI)

Description:
find location radius based on building density from center

Arguments:
0: center position <ARRAY>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"
#define RADIUS_MIN 50
#define RADIUS_MAX 500
#define RADIUS_STEP 50
#define BLACKLIST []

params [
    ["_position",[],[[]]]
];

_position =+ _position;
_position resize 2;

private _countCurrent = 0;
private _countPreviousTotal = 0;
private _countPreviousIteration = 0;
private _ret = 0;

for "_r" from RADIUS_MIN to RADIUS_MAX step RADIUS_STEP do {
    // house count for current iteration
    _countCurrent = (count (_position nearObjects ["House",_r])) - _countPreviousTotal;

    // exit if house count falls off or loop finishes
    if (_countCurrent <= (ceil (_countPreviousTotal * 0.1)) || {_r isEqualTo (RADIUS_MIN + RADIUS_STEP * (floor ((RADIUS_MAX - RADIUS_MIN) / RADIUS_STEP)))}) exitWith {
        if !(_r isEqualTo RADIUS_MIN) then {
            _ret = _r;
        }; 
    };

    _countPreviousIteration = _countCurrent;
    _countPreviousTotal = _countPreviousTotal + _countCurrent;
};

_ret