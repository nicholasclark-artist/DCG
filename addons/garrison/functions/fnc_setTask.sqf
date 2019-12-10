/*
Author:
Nicholas Clark (SENSEI)

Description:


Arguments:

Return:

__________________________________________________________________*/
#include "script_component.hpp"

private ["_id","_situation","_mission","_description","_sustainment","_ao","_name"];

// set area tasks
[GVAR(areas),{
    // set task id
    _id = ["ao",_key] joinString "_";
    _id = _id select [0,8];
    _value setVariable [QGVAR(task),_id];

    // setup description
    _name = _value getVariable [QGVAR(name),""];
    _situation = format ["...",_name];
    _mission = format ["...",_name];

    _description = [_value,_situation,_mission] call FUNC(taskOPORD);

    // create task
    [true,_id,[_description select 1,_description select 0,""],[_value getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON]] call EFUNC(main,polygonCentroid),"CREATED",-1,false,_name select [0,1]] call BIS_fnc_taskCreate;

    TRACE_2("ao task",_key,_id);
}] call CBA_fnc_hashEachPair;

// set garrison tasks
[GVAR(areas),{
    // set task id
    _id = ["gar",_key] joinString "_";
    _id = _id select [0,8];
    _value setVariable [QGVAR(taskGarrison),_id];


    // setup description
    _name = _value getVariable [QGVAR(nameGarrison),""];

    _situation = format ["Some time ago,a convoy of military logistics and engineering vehicles was spotted entering AO %1. These vehicles are likely supporting the construction of an enemy outpost (OBJ %2). Previous engagements have shown the enemy to be composed of dismounted patrols and potentially,static emplacements. They are expected to defend upon contact.",_value getVariable [QGVAR(name),""],_name];
    _mission = format ["Friendly forces will conduct an operation in AO %1 to locate and secure OBJ %2 in order to prevent anti-coalition forces from gaining momentum and swaying civilian approval.",_value getVariable [QGVAR(name),""],_name];
    _sustainment = ["","","","","Each Soldier will carry his/her full basic load.","","","All squads will maintain necessary medical equipment and will ensure it is replenished prior to each movement.","",""];

    _description = [_value,_situation,_mission,_sustainment] call FUNC(taskOPORD);

    // create task
    [true,[_id,_value getVariable [QGVAR(task),""]],[_description select 1,_description select 0,""],objNull,"CREATED",0,true,"attack"] call BIS_fnc_taskCreate;

    TRACE_2("gar task",_key,_id);
}] call CBA_fnc_hashEachPair;

// set outpost tasks 
[GVAR(outposts),{
    // set task id
    _id = ["op",_key] joinString "_";
    _id = _id select [0,8];
    _value setVariable [QGVAR(task),_id];

    // setup description
    _ao = [GVAR(areas),_key] call CBA_fnc_hashGet;
    _name = _value getVariable [QGVAR(name),""];

    _situation = format ["Some time ago,a convoy of military logistics and engineering vehicles was spotted entering AO %1. These vehicles are likely supporting the construction of an enemy outpost (OBJ %2). Previous engagements have shown the enemy to be composed of dismounted patrols and potentially,static emplacements. They are expected to defend upon contact.",_ao getVariable [QGVAR(name),""],_name];
    _mission = format ["Friendly forces will conduct an operation in AO %1 to locate and secure OBJ %2 in order to prevent anti-coalition forces from gaining momentum and swaying civilian approval.",_ao getVariable [QGVAR(name),""],_name];
    _sustainment = ["","","","","Each Soldier will carry his/her full basic load.","","","All squads will maintain necessary medical equipment and will ensure it is replenished prior to each movement.","",""];

    _description = [_value,_situation,_mission,_sustainment] call FUNC(taskOPORD);

    // create task
    [true,[_id,_ao getVariable [QGVAR(task),""]],[_description select 1,_description select 0,""],objNull,"CREATED",0,true,"attack"] call BIS_fnc_taskCreate;

    TRACE_2("op task",_key,_id);
}] call CBA_fnc_hashEachPair;

// set dynamic tasks 
