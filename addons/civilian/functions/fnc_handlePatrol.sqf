/*
Author:
Nicholas Clark (SENSEI)

Description:
set patrol

Arguments:
0: unit <OBJECT>
1: location to patrol <LOCATION>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define WAIT_POSEVENT 180
#define MOVETO_COMPLETE(AGENT) AGENT moveTo (getPos AGENT)

(_this select 0) params [
    ["_agent",objNull,[objNull]],
    ["_location",locationNull,[locationNull]]
];

// @todo add check for unit getting stuck at random positions
private _position = getPos _location;
private _radius = (size _location) select 0;
private _buildingPositions = _location getVariable [QGVAR(buildingPositions),[]];
private _prefabPositions = _location getVariable [QGVAR(prefabPositions),[]];
private _animObjects = _location getVariable [QGVAR(animObjects),[]];
private _types = [];

{
    if (_x select 1) then {
        _types pushBack (_x select 0);
    };
} forEach [
    ["random",rain < 0.25],
    ["building",!(_buildingPositions isEqualTo [])],
    ["prefab",!(_prefabPositions isEqualTo []) && rain < 0.25],
    ["anim",!(_animObjects isEqualTo []) && rain < 0.25]
];

if (_types isEqualTo []) exitWith {
    WARNING_1("no patrol types for %1",_agent);
};

// reset moveToCompleted on first cycle
if !(_agent getVariable [QGVAR(patrol),false]) then {
    MOVETO_COMPLETE(_agent);
    _agent setVariable [QGVAR(patrol),true];
};

// exit code
if (!alive _agent || {!(_agent getVariable [QGVAR(patrol),false])}) exitWith {
    [_this select 1] call CBA_fnc_removePerFrameHandler;
};

if (moveToCompleted _agent && {!(_agent getVariable [QGVAR(panic),false])} && {!(_agent getVariable [QGVAR(waiting),false])}) then {
    private ["_posMove","_posEvent","_moveToPositions","_obj"];

    // free up last moveTo position
    _moveToPositions = _location getVariable [QGVAR(moveToPositions),[]];
    _moveToPositions deleteAt (_moveToPositions find (_agent getVariable [QGVAR(moveTo),[]]));
    _location setVariable [QGVAR(moveToPositions),_moveToPositions];

    // select position to move to
    switch (selectRandom _types) do {
        case "random": { // random position
            _posMove = _position getPos [(random (_radius - (_radius * 0.2))) + (_radius * 0.2), random 360];
            _posMove = [_posMove,nil] select (surfaceIsWater _posMove);

            if !(isNil "_posMove") then {
                _posMove = ASLToATL (AGLToASL _posMove);
            };

            TRACE_2("select random pos",_agent,_posMove);
        };
        case "building": { // building position
            _posMove = selectRandom (selectRandom _buildingPositions);
            _posMove = ASLToATL (AGLToASL _posMove);

            TRACE_2("select building pos",_agent,_posMove);
        };
        case "anim": { // anim object position
            _obj = selectRandom _animObjects;
            _posMove = getPosATL _obj;

            // position event
            _agent setVariable [QGVAR(positionEventCondition),{CHECK_DIST(getPosATL (_this select 0),_this select 2,5) && {moveToCompleted (_this select 0)}}];
            _agent setVariable [QGVAR(positionEventParams),[_agent,_obj,_posMove]];

            _posEvent = {
                params ["_agent","_obj"];

                TRACE_2("pos event",_this,WAIT_POSEVENT);

                _agent setVariable [QGVAR(waiting),true];

                detach _agent;
                {_agent disableAI _x} forEach ["ANIM","MOVE"];
                
                // avoid unit sliding in seat
                _agent disableCollisionWith _obj;
                _agent setVelocity [0,0,0];
                
                private _animData = [getModelInfo _obj] call FUNC(getAnimData);

                [_agent,"amovpknlmstpsraswrfldnon",2] call EFUNC(main,setAnim);
                [_agent,selectRandom (_animData select 2),2] call EFUNC(main,setAnim);

                _agent setDir (getDir _obj + (_animData select 1));
                _agent setPosASL (AGLtoASL (_obj modelToWorld (_animData select 0)));

                // stand up
                [
                    {
                        params ["_agent","_obj"];

                        if (alive _agent && {_agent getVariable [QGVAR(waiting),false]}) then {
                            _agent setVariable [QGVAR(waiting),false];

                            if !(_agent getVariable [QGVAR(panic),false]) then {
                                [_agent,"",2] call EFUNC(main,setAnim);
                                _agent setVehiclePosition [getPosATL _agent,[],0,"NONE"];
                                {_agent enableAI _x} forEach ["ANIM","MOVE"];
                                _agent enableCollisionWith _obj;
                                MOVETO_COMPLETE(_agent);
                            };
                        };  
                    },
                    [_agent,_obj],
                    WAIT_POSEVENT
                ] call CBA_fnc_waitandExecute;
            };

            TRACE_2("select anim pos",_agent,_posMove);
        };
        case "prefab": { // prefab node position
            _posMove = (selectRandom _prefabPositions) select 0;

            // position event
            _agent setVariable [QGVAR(positionEventCondition),{CHECK_DIST(getPosATL (_this select 0),_this select 1,5) && {moveToCompleted (_this select 0)}}];
            _agent setVariable [QGVAR(positionEventParams),[_agent,_posMove]];

            _posEvent = {
                params ["_agent"];

                TRACE_1("pos event",_this);

                _agent setVariable [QGVAR(waiting),true];

                detach _agent;
                {_agent disableAI _x} forEach ["ANIM","MOVE"];
                
                // avoid unit sliding in seat
                _agent setVelocity [0,0,0];

                [_agent,"amovpknlmstpsraswrfldnon",2] call EFUNC(main,setAnim);

                // release from prefab
                [
                    {
                        params ["_agent"];

                        if (alive _agent && {_agent getVariable [QGVAR(waiting),false]}) then {
                            _agent setVariable [QGVAR(waiting),false];

                            if !(_agent getVariable [QGVAR(panic),false]) then {
                                [_agent,"",2] call EFUNC(main,setAnim);
                                {_agent enableAI _x} forEach ["ANIM","MOVE"];
                                MOVETO_COMPLETE(_agent);
                            };
                        };  
                    },
                    [_agent],
                    WAIT_POSEVENT
                ] call CBA_fnc_waitandExecute;
            };

            TRACE_2("select prefab pos",_agent,_posMove);
        };
        default {WARNING("unknown patrol type")};
    };

    if !(isNil "_posMove") then {
        // move to position if available
        if !(_posMove in (_location getVariable [QGVAR(moveToPositions),[]])) then {
            _agent moveTo _posMove;

            TRACE_2("moving",_agent,_posMove);

            // run event at position if available
            if !(isNil "_posEvent") then {
                [
                    _agent getVariable [QGVAR(positionEventCondition),{false}],
                    _posEvent,
                    _agent getVariable [QGVAR(positionEventParams),[]],
                    (((((getPosATL _agent) distanceSqr _posMove)/1000)/5)*3600)*2,
                    {
                        WARNING_1("timeout. skip position event %1",_this);
                    }
                ] call CBA_fnc_waitUntilAndExecute;
            }; 
            
            // keep track of unavailable positions
            _agent setVariable [QGVAR(moveTo),_posMove];
            _moveToPositions = _location getVariable [QGVAR(moveToPositions),[]];
            _moveToPositions pushBack _posMove;
            _location setVariable [QGVAR(moveToPositions),_moveToPositions];

            TRACE_2("location positions",count _moveToPositions,_moveToPositions);
        };
    };
};

nil