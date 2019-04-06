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

params ["_args","_idPFH"];
_args params [
    ["_agent",objNull,[objNull]],
    ["_location",locationNull,[locationNull]]
];

// @todo fix unit getting stuck
private _position = getPos _location;
private _radius = (size _location) select 0;
private _buildingPositions = _location getVariable [QGVAR(buildingPositions),[]];
// private _prefabPositions = _location getVariable [QGVAR(prefabPositions),[]];
private _animObjects = _location getVariable [QGVAR(animObjects),[]];
private _typeMove = 1;

if !(_buildingPositions isEqualTo []) then {
    _typeMove = _typeMove + 1;
};

if !(_animObjects isEqualTo []) then {
    _typeMove = _typeMove + 1;
};

// if !(_prefabPositions isEqualTo []) then {
//     _typeMove = _typeMove + 1;
// };

// reset moveToCompleted on first cycle
if !(_agent getVariable [QGVAR(patrol),false]) then {
    _agent moveTo (getPosATL _agent);
    _agent setVariable [QGVAR(patrol),true];
};

// exit code
if (!alive _agent || {!(_agent getVariable [QGVAR(patrol),false])}) exitWith {
    [_idPFH] call CBA_fnc_removePerFrameHandler;
};

if (moveToCompleted _agent && {!(_agent getVariable [QGVAR(panic),false])} && {!(_agent getVariable [QGVAR(waiting),false])}) then {
    private ["_posMove","_posEvent","_moveToPositions","_obj"];

    // free up last moveTo position
    _moveToPositions = _location getVariable [QGVAR(moveToPositions),[]];
    _moveToPositions deleteAt (_moveToPositions find (_agent getVariable [QGVAR(moveTo),[]]));
    _location setVariable [QGVAR(moveToPositions),_moveToPositions];

    // select position to move to
    switch (floor random _typeMove) do {
        case 0: { // random position
            _posMove = _position getPos [(random (_radius - (_radius * 0.2))) + (_radius * 0.2), random 360];
            _posMove = [_posMove,nil] select (surfaceIsWater _posMove);

            if !(isNil "_posMove") then {
                _posMove set [2,ASLToATL (getTerrainHeightASL _posMove)];
            };

            TRACE_2("select random pos",_agent,_posMove);
        };
        case 1: { // building position
            _posMove = selectRandom (selectRandom _buildingPositions);

            TRACE_2("select building pos",_agent,_posMove);
        };
        case 2: { // anim object position
            _obj = selectRandom _animObjects;
            _posMove = getPosATL _obj;
            _agent setVariable [QGVAR(waiting),true];

            _posEvent = {
                params ["_agent","_obj"];

                TRACE_1("pos event",_this);

                _agent stop true;
                _agent moveTo (getPosATL _agent);

                private _animData = [getModelInfo _obj] call FUNC(getAnimData);
                [_agent,"amovpknlmstpsraswrfldnon",2] call EFUNC(main,setAnim);
                [_agent,selectRandom (_animData select 2),2] call EFUNC(main,setAnim);

                _agent setDir (getDir _obj + (_animData select 1));
                _agent setPosASL (AGLtoASL (_obj modelToWorld (_animData select 0)));

                [
                    {
                        params ["_agent"];

                        if (alive _agent && {_agent getVariable [QGVAR(waiting),false]}) then {
                            _agent setVariable [QGVAR(waiting),false];

                            if !(_agent getVariable [QGVAR(panic),false]) then {
                                [_agent,"",2] call EFUNC(main,setAnim);
                                _agent stop false;
                                _agent moveTo (getPosATL _agent);
                            };
                        };  
                    },
                    [_agent],
                    300
                ] call CBA_fnc_waitandExecute;
            };

            TRACE_2("select anim pos",_agent,_posMove);
        };
        case 2: { // prefab node position
            _posMove = (selectRandom _prefabPositions) select 0;
            _agent setVariable [QGVAR(waiting),true];

            [
                {
                    if (alive (_this select 0) && {(_this select 0) getVariable [QGVAR(waiting),false]}) then {
                        (_this select 0) setVariable [QGVAR(waiting),false];
                    };  
                },
                [_agent],
                300
            ] call CBA_fnc_waitandExecute;

            TRACE_2("select prefab pos",_agent,_posMove);
        };
        default {};
    };

    if !(isNil "_posMove") then {
        // move to position if available
        if ((_posMove nearEntities [["Man"],0.5]) isEqualTo [] && {!(_posMove in (_location getVariable [QGVAR(moveToPositions),[]]))}) then {
            _agent moveTo _posMove;

            TRACE_2("moving",_agent,_posMove);

            if !(isNil "_posEvent") then {
                [
                    {CHECK_DIST(getPosATL (_this select 0),_this select 2,2)},
                    _posEvent,
                    [_agent,_obj,_posMove],
                    (((((getPosATL _agent) distanceSqr _posMove)/1000)/5)*3600)*2,
                    {
                        WARNING_1("%1 timeout. skip position event",_this select 0);
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