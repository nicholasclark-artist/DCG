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

[GVAR(outposts),{
    private _unitCount = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
    private _unitCountBuildings = ceil (_unitCount * 0.6);
    private _unitCountPatrol = floor (_unitCount - _unitCountBuildings);

    private _groups = [_value,EGVAR(main,enemySide),_unitCountBuildings,_unitCountPatrol, round random 1] call FUNC(spawnUnit);

    sleep _unitCount;

    private _type = _value getVariable [QGVAR(compositionType),""];

    private ["_composition","_intel"];

    if !(COMPARE_STR(_type,"none")) then {
        if (COMPARE_STR(_type,"")) then {
            // spawn compositions for certain terrain type
            _type = (_value getVariable [QGVAR(terrain),""]) call {
                if (COMPARE_STR(_this,"meadow")) exitWith {"mil_cop"};
                if (COMPARE_STR(_this,"peak")) exitWith {"mil_pb"};
                if (COMPARE_STR(_this,"forest")) exitWith {"mil_pb"};

                "mil_pb"
            };
        };

        // spawn composition after units so units are aware of buildings
        _composition = [_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS],_type,random 360,true] call EFUNC(main,spawnComposition);

        // outpost intel
        _intel = objNull;

        private "_intelSurface";

        // check outpost composition for intel placement or spawn intel composition
        private _intelObjects = (_composition select 2) select {toLower typeOf _x in INTEL_S_CLASSES};

        if !(_intelObjects isEqualTo []) then {
            _intelSurface = selectRandom _intelObjects;
        } else {
            private _intelNodes = (_composition select 3) select {(_x select 1) >= 1};

            if (_intelNodes isEqualTo []) exitWith {};

            _intelSurface = createSimpleObject [selectRandom INTEL_S_CLASSES,DEFAULT_SPAWNPOS];
            _intelSurface setDir (random 360);
            [_intelSurface,ATLtoASL ((selectRandom _intelNodes) select 0)] call EFUNC(main,setPosSafe);
        };

        // create intel item
        if !(isNil "_intelSurface") then {
            private _size = [_intelSurface] call EFUNC(main,getObjectSize);

            private _intelPos = getPosASL _intelSurface;
            _intelPos = _intelPos vectorAdd [0,0,(_size select 1) + 0.01];

            _intel = createVehicle [selectRandom INTEL_CLASSES,DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
            _intel enableSimulationGlobal false;

            _intel setDir (random 360);
            [_intel,_intelPos] call EFUNC(main,setPosSafe);

            // remove any default intel actions
            [_intel] remoteExecCall [QUOTE(removeAllActions),0,false];

            if (isNull GVAR(intel)) then {
                GVAR(intel) = _intel;
            };
        } else {
            ERROR_1("%1 does not have a suitable intel surface",_composition select 0);

            // @todo add intel at default position
        };

        // intel action
        [
            [_intel],
            {
                params ["_intel"];

                [_intel, "Gather Intel", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa", "true", "true", {}, {}, {[QGVAR(intel),[_this select 0]] call CBA_fnc_serverEvent}, {}, [], 5, 100, true, false, true] call BIS_fnc_holdActionAdd;
            }
        ] remoteExecCall [QUOTE(call),0,_intel];
    };

    // set groups to defend composition
    {
        [
            {(_this select 0) getVariable [QEGVAR(main,ready),false]},
            {
                [_this select 0,getPos (_this select 1),50,0] call EFUNC(main,taskDefend);
                [QEGVAR(cache,enableGroup),_this select 0] call CBA_fnc_serverEvent;
            },
            [_x,_value],
            60
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2
    } forEach (_groups select 0);

    // set groups to patrol
    {
        [
            {_this getVariable [QEGVAR(main,ready),false]},
            {
                [_this,getPos leader _this,random [100,150,300],1,"if (0.1 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
            },
            _x,
            60
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2;
    } forEach (_groups select 1);

    // set vehicles on patrol
    {
        [
            {_this getVariable [QEGVAR(main,ready),false]},
            {
                // disable waking cached units on air patrols
                if (vehicle leader _this isKindOf "Air") then {
                    {
                        _x triggerDynamicSimulation false;
                    } forEach units _this;
                };
                [_this,getPos leader _this,300,0] call EFUNC(main,taskPatrol);
            },
            _x,
            60
        ] call CBA_fnc_waitUntilAndExecute;

        sleep 0.2;
    } forEach (_groups select 2);

    // setvars
    _value setVariable [QGVAR(radius),_composition select 1];
    _value setVariable [QGVAR(nodes),_composition select 3];
    _value setVariable [QGVAR(composition),_composition select 2];
    _value setVariable [QGVAR(intel),_intel];

    _intel setVariable [QGVAR(intelKey),_key];

    private _mrk = createMarker [format["%1%2",_key,_value getVariable [QGVAR(type),""]],getPos _value];
    _mrk setMarkerType "o_installation";
    _mrk setMarkerColor ([EGVAR(main,enemySide),true] call BIS_fnc_sideColor);
    _mrk setMarkerSize [0.75,0.75];
    _mrk setMarkerText (_composition select 0);
    [_mrk] call EFUNC(main,setDebugMarker);
}] call CBA_fnc_hashEachPair;

nil