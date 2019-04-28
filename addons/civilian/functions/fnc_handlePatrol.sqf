/*
Author:
Nicholas Clark (SENSEI)

Description:
handle patrols

Arguments:
0: location to patrol <LOCATION>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define POSEVENT_WAIT 60

// agent will complete moveTo commands in order of execution
// moveTo commands do not overwrite each other unless CIV_MOVETO_COMPLETE is used
[{
    params ["_args","_idPFH"];
    _args params ["_location"];

    // exit code
    if !(_location getVariable [QGVAR(active),false]) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    // @todo add check for unit getting stuck at random positions
    private _position = getPos _location;
    private _radius = (size _location) select 0;
    private _buildingPositions = _location getVariable [QGVAR(buildingPositions),[]];
    private _prefabPositions = _location getVariable [QGVAR(prefabPositions),[]];
    private _animObjects = _location getVariable [QGVAR(animObjects),[]];
    private _types = [];

    // get suitable patrol types
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
        WARNING_1("no patrol types for %1",_location);
    };

    private ["_agent"];

    {
        _agent = _x;
        
        // reset moveToCompleted on first cycle
        if !(_agent getVariable [QGVAR(active),false]) then {
            CIV_MOVETO_COMPLETE(_agent);
            
            _agent setVariable [QGVAR(active),true];
            _agent setVariable [QGVAR(patrol),true];
        };

        if (moveToCompleted _agent && {(_agent getVariable [QGVAR(patrol),false])} && {!(_agent getVariable [QGVAR(panic),false])}) then {
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
                    _posMove = getPos _obj;

                    // position event
                    _agent setVariable [QGVAR(positionEventCondition),{CHECK_DIST2D(getPos (_this select 0),_this select 2,5) && {moveToCompleted (_this select 0)}}];
                    _agent setVariable [QGVAR(positionEventParams),[_agent,_obj,_posMove]];

                    // @todo fix unsuitable anim objects being selected
                    _posEvent = {
                        params ["_agent","_obj"];

                        TRACE_1("pos event",_this);

                        _agent setVariable [QGVAR(patrol),false];

                        [_agent,"object",_obj] call EFUNC(main,setAmbientAnim);

                        // stand up
                        [
                            {
                                params ["_agent"];

                                if !(_agent getVariable [QGVAR(patrol),false]) then {
                                    _agent setVariable [QGVAR(patrol),true];

                                    if !(_agent getVariable [QGVAR(panic),false]) then {
                                        [_agent] call EFUNC(main,removeAmbientAnim);
                                        CIV_MOVETO_COMPLETE(_agent);
                                    };
                                };  
                            },
                            [_agent],
                            POSEVENT_WAIT
                        ] call CBA_fnc_waitandExecute;
                    };

                    TRACE_2("select anim pos",_agent,_posMove);
                };
                case "prefab": { // prefab node position
                    _posMove = (selectRandom _prefabPositions) select 0;

                    // position event
                    _agent setVariable [QGVAR(positionEventCondition),{CHECK_DIST2D(getPos (_this select 0),_this select 1,5) && {moveToCompleted (_this select 0)}}];
                    _agent setVariable [QGVAR(positionEventParams),[_agent,_posMove]];

                    _posEvent = {
                        params ["_agent"];

                        TRACE_1("pos event",_this);

                        _agent setVariable [QGVAR(patrol),false];

                        [_agent] call EFUNC(main,setAmbientAnim);

                        // release from prefab
                        [
                            {
                                params ["_agent"];

                                if !(_agent getVariable [QGVAR(patrol),false]) then {
                                    _agent setVariable [QGVAR(patrol),true];

                                    if !(_agent getVariable [QGVAR(panic),false]) then {
                                        [_agent] call EFUNC(main,removeAmbientAnim);
                                        CIV_MOVETO_COMPLETE(_agent);
                                    };
                                };  
                            },
                            [_agent],
                            POSEVENT_WAIT
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
                            (((((getPos _agent) distanceSqr _posMove)/1000)/5)*3600)*2,
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
    } forEach (_location getVariable [QGVAR(units),[]]);
}, 60, _this] call CBA_fnc_addPerFrameHandler; 

nil