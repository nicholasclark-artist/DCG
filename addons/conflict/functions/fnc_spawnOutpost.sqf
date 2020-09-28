/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn outposts, should not be called directly and must run in scheduled environment

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private ["_unitCount","_unitCountBuildings","_unitCountPatrol","_groups","_intelNodes","_intelObjects","_intelPos","_intel","_terrain","_composition","_size"];

[GVAR(outposts),{
    _unitCount = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
    _unitCountBuildings = ceil (_unitCount * 0.5);
    _unitCountPatrol = floor (_unitCount - _unitCountBuildings);

    _groups = [_value,EGVAR(main,enemySide),_unitCountBuildings,_unitCountPatrol, round random 1] call FUNC(spawnUnit);

    // spawn compositions for certain terrain type
    _terrain = (_value getVariable [QGVAR(terrain),""]) call {
        if (COMPARE_STR(_this,"meadow")) exitWith {"mil_cop"};
        if (COMPARE_STR(_this,"peak")) exitWith {"mil_pb"};
        if (COMPARE_STR(_this,"forest")) exitWith {"mil_pb"};

        "mil_pb"
    };

    // spawn composition after units so units are aware of buildings
    _composition = [_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS],_terrain,random 360,true] call EFUNC(main,spawnComposition);

    // set groups to defend composition
    {
        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                [_this select 0,getPos (_this select 1),50,0] call EFUNC(main,taskDefend);
                [QEGVAR(cache,enableGroup),_this] call CBA_fnc_serverEvent;
            },
            [_x,_value],
            10
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2
    } forEach (_groups select 0);

    // set groups to patrol
    {
        [
            {_this getVariable [QEGVAR(main,ready),false]},
            {
                [_this,getPosATL leader _this,random [100,200,500],1,"if (0.1 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
            },
            _x,
            10
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2;
    } forEach (_groups select 1);

    // set vehicles on patrol
    {
        [
            {_this getVariable [QEGVAR(main,ready),false]},
            {
                [_this,getPosATL leader _this,400,0] call EFUNC(main,taskPatrol);
            },
            _x,
            10
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2;
    } forEach (_groups select 2);

    // outpost intel
    if (_value getVariable [QGVAR(intelStatus),false]) then {
        private "_intelSurface";

        // check outpost composition for intel placement or spawn intel composition
        _intelObjects = (_composition select 2) select {toLower typeOf _x in INTEL_SURFACES};

        if !(_intelObjects isEqualTo []) then {
            _intelSurface = selectRandom _intelObjects;
        } else {
            _intelNodes = (_composition select 1) select {(_x select 1) >= 1};

            if (_intelNodes isEqualTo []) exitWith {};

            _intelSurface = createSimpleObject [selectRandom INTEL_SURFACES,DEFAULT_SPAWNPOS];
            _intelSurface setDir (random 360);
            [_intelSurface,ATLtoASL ((selectRandom _intelNodes) select 0)] call EFUNC(main,setPosSafe);
        };

        // create intel item
        if !(isNil "_intelSurface") then {
            _size = [_intelSurface] call EFUNC(main,getObjectSize);

            _intelPos = getPosASL _intelSurface;
            _intelPos = _intelPos vectorAdd [0,0,(_size select 1) + 0.01];

            _intel = createVehicle [selectRandom INTEL_ITEMS,DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
            _intel enableSimulationGlobal false;

            _intel setDir (random 360);
            [_intel,_intelPos] call EFUNC(main,setPosSafe);

            // remove any default intel actions
            removeAllActions _intel;

            if (isNull GVAR(intel)) then {
                GVAR(intel) = _intel;
            };
        } else {
            ERROR_1("%1 does not have a suitable intel surface",_composition select 3);

            // @todo add intel at default position
        };

        // intel action
        [
            [_intel],
            {
                params ["_intel"];

                [_intel, "Gather Intel", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa", "true", "true", {}, {}, {[QGVAR(intel),[_this select 0]] call CBA_fnc_serverEvent}, {}, [], 5, 100, true, false, true] call BIS_fnc_holdActionAdd;
            }
        ] remoteExecCall [QUOTE(call),0,GVAR(intel)];
    };

    // setvars
    _value setVariable [QGVAR(radius),_composition select 0];
    _value setVariable [QGVAR(nodes),_composition select 1];
    _value setVariable [QGVAR(composition),_composition select 2];
    _value setVariable [QGVAR(intel),_intel];

    _intel setVariable [QGVAR(intelKey),_key];
}] call CBA_fnc_hashEachPair;

nil