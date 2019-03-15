/*
Author:
Nicholas Clark (SENSEI)

Description:
populate unit pools

0 = East
1 = West
2 = Resistance
3 = Civilian

Arguments:
0: config side <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _side = _this select 0;

if (_side isEqualTo 0) exitWith {
    _ret = [_side, GVAR(factionsEast), GVAR(filtersEast)] call FUNC(parseFactions);

    GVAR(unitsEast) = _ret select 0;
    GVAR(vehiclesEast) = _ret select 1;
    GVAR(aircraftEast) = _ret select 2;
    GVAR(officersEast) = _ret select 3;
    GVAR(snipersEast) = _ret select 4;
};

if (_side isEqualTo 1) exitWith {
    _ret = [_side, GVAR(factionsWest), GVAR(filtersWest)] call FUNC(parseFactions);

    GVAR(unitsWest) = _ret select 0;
    GVAR(vehiclesWest) = _ret select 1;
    GVAR(aircraftWest) = _ret select 2;
    GVAR(officersWest) = _ret select 3;
    GVAR(snipersWest) = _ret select 4;
};

if (_side isEqualTo 2) exitWith {
    _ret = [_side, GVAR(factionsInd), GVAR(filtersInd)] call FUNC(parseFactions);

    GVAR(unitsInd) = _ret select 0;
    GVAR(vehiclesInd) = _ret select 1;
    GVAR(aircraftInd) = _ret select 2;
    GVAR(officersInd) = _ret select 3;
    GVAR(snipersInd) = _ret select 4;
};

if (_side isEqualTo 3) exitWith {
    _ret = [_side, GVAR(factionsCiv), GVAR(filtersCiv)] call FUNC(parseFactions);

    GVAR(unitsCiv) = _ret select 0;
    GVAR(vehiclesCiv) = _ret select 1;
    GVAR(aircraftCiv) = _ret select 2;
};


nil