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
#define SPAWN_DELAY (1 max 0.1)

private ["_position","_unitCount","_unitCountBuildings","_unitCountPatrol","_posBuildings","_posPatrol","_grp","_intelNodes","_intelObjects","_intelPos","_intel","_terrain","_composition","_type","_size"];

[GVAR(outposts),{
    _position = _value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS];

    _unitCount = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
    _unitCountBuildings = ceil (_unitCount * 0.5);
    _unitCountPatrol = floor (_unitCount - _unitCountBuildings);

    /*
        building infantry
    */

    // get safe position for units away from composition, radius is an estimate
    _posBuildings = [_position,50,100,2,0,-1,[0,360],_position getPos [50,random 360]] call EFUNC(main,findPosSafe);

    // spawn building infantry, units will defend composition, defer caching
    for "_i" from 1 to floor (1 max (_unitCountBuildings / PAT_GRPSIZE)) do {
        _grp = [_posBuildings,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY,0,true] call EFUNC(main,spawnGroup);

        [QGVAR(updateGroups),[_value,_grp]] call CBA_fnc_localEvent;

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * PAT_GRPSIZE);
    };

    // spawn compositions for certain terrain type
    _terrain = (_value getVariable [QGVAR(terrain),""]) call {
        if (COMPARE_STR(_this,"meadow")) exitWith {"mil_cop"};
        if (COMPARE_STR(_this,"peak")) exitWith {"mil_pb"};
        if (COMPARE_STR(_this,"forest")) exitWith {"mil_pb"};

        "mil_pb"
    };

    _composition = [_position,_terrain,random 360,true] call EFUNC(main,spawnComposition);

    // set groups to defend composition
    {
        [_x,getPos _value,50,0] call EFUNC(main,taskDefend);

        sleep 0.2;
    } forEach (_value getVariable [QGVAR(groups),[]]);

    // give defending groups time to reach positions before caching
    [
        {
            {
                [QEGVAR(cache,enableGroup),_x] call CBA_fnc_serverEvent;
            } forEach _this;
        },
        +(_value getVariable [QGVAR(groups),[]]),
        10
    ] call CBA_fnc_waitAndExecute;

    /*
        patrol infantry
    */

    // get patrol spawn position in safe area around composition
    _posPatrol = [_position,(_composition select 0) + 10,(_composition select 0) + 50,2,0,-1,[0,360],_position getPos [(_composition select 0) + 20,random 360]] call EFUNC(main,findPosSafe);

    // spawn infantry patrols, patrols will navigate outpost exterior and investigate nearby buildings
    for "_i" from 1 to floor (1 max (_unitCountPatrol / PAT_GRPSIZE)) do {
        _grp = [_posPatrol,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

        [
            {(_this select 1) getVariable [QEGVAR(main,ready),false]},
            {
                [QGVAR(updateGroups),_this] call CBA_fnc_localEvent;

                // set group on patrol
                [_this select 1,getPos (_this select 0),random [100,200,500],1,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
            },
            [_value,_grp],
            (SPAWN_DELAY * PAT_GRPSIZE) * 2
        ] call CBA_fnc_waitUntilAndExecute;

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * PAT_GRPSIZE);
    };

    /*
        outpost intel
    */

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

            [_intel, "Gather Intel", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_hack_ca.paa", "true", "true", {}, {}, {[QGVAR(intel),[_this select 0,_this select 1]] call CBA_fnc_serverEvent}, {}, [], 5, 100, true, false, true] call BIS_fnc_holdActionAdd;
        }
    ] remoteExecCall [QUOTE(call),0,GVAR(intel)];

    // setvars
    _value setVariable [QGVAR(radius),_composition select 0];
    _value setVariable [QGVAR(nodes),_composition select 1];
    _value setVariable [QGVAR(composition),_composition select 2];
    _value setVariable [QGVAR(intel),_intel];
}] call CBA_fnc_hashEachPair;

nil