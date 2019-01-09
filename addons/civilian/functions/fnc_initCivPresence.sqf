/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian unit spawns using Civilian Presence modules

Arguments:
0: location array <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

{
    _x params ["_name","_position","_radius","_type"];

    _position = ASLtoAGL _position;

    if (GVAR(blacklist) find _name isEqualTo -1) then {
        private _trg = createTrigger ["EmptyDetector", _position, true]; // local trigger creates 'Ref to nonnetwork object' spam in log
        _trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
        _trg setTriggerStatements ["this", format ["hint '%1: ON'",_name], format ["hint '%1: OFF'",_name]]; // @todo delay trigger check
        _trg setTriggerArea [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist), 0, false]; // @todo test z-dist

        private _count = call {
            if (_type isEqualTo "NameVillage") exitWith {ceil(CIV_VILLAGE_COUNT*GVAR(multiplier))};
            if (_type isEqualTo "NameCity") exitWith {ceil(CIV_CITY_COUNT*GVAR(multiplier))};

            ceil(CIV_CAPITAL_COUNT*GVAR(multiplier));
        };
        
        // main module is immediately moved to ambient group, _grp is null after module creation
        private _grp = createGroup sideLogic;
        private _moduleMain = _grp createUnit ["ModuleCivilianPresence_F", _position, [], 0, "CAN_COLLIDE"];
        
        // main module does not init sometimes, even with 'BIS_fnc_initModules_disableAutoActivation'
        // force init with 'bis_fnc_initmodules_activate'
        _moduleMain setVariable ["BIS_fnc_initModules_disableAutoActivation",false,true]; // @todo check if public is required
        _moduleMain setVariable ["bis_fnc_initmodules_activate",true,true]; // @todo check if public is required

        // main options
        _moduleMain setVariable ["#area",[_position,_radius,_radius,0,false,-1]]; // gets passed to inAreaArray @todo test z-dist
        _moduleMain setVariable ["#debug",true];
        _moduleMain setVariable ["#useagents",true];
        _moduleMain setVariable ["#usepanicmode",true];
        _moduleMain setVariable ["#unitcount",_count];
        _moduleMain setVariable ["#unittypes",EGVAR(main,unitsCiv)];
        _moduleMain setVariable ["#oncreated",{true}];
        _moduleMain setVariable ["#ondeleted",{true}];

        // sync main module to trigger
        _moduleMain synchronizeObjectsAdd [_trg];

        private _step = 360 / _count;
        private _offset = random _step;
        private _check = [];

        [{
            params ["_args","_idPFH"];
            _args params ["_name","_position","_radius","_trg","_count","_step","_offset","_check"];   

            if (count _check isEqualTo _count) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };

            // find spawn position
            private _i = (count _check) + 1;
            private _theta = (_i % 2) * 180 + sin (deg (_step * _i)) * _offset + _step * _i;
            _radius = _radius * random [0, 0.3, 0.75];
            _position = _position getPos [_radius, _theta];

            if (_name == "Kalithea") then {
                TRACE_2("",count _check,surfaceIsWater _position);
            };

            if !(surfaceIsWater _position) then {
                // create new group, old group is null
                private _grp = createGroup sideLogic;
                private _moduleSpawn = _grp createUnit ["ModuleCivilianPresenceUnit_F", _position, [], 0, "CAN_COLLIDE"];

                _moduleSpawn setVariable ["BIS_fnc_initModules_disableAutoActivation",false,true]; // @todo check if public is required
                _moduleSpawn setVariable ["bis_fnc_initmodules_activate",true,true]; // @todo check if public is required

                _grp = createGroup sideLogic;
                private _moduleWaypoint = _grp createUnit ["ModuleCivilianPresenceSafeSpot_F", _position, [], 0, "CAN_COLLIDE"];

                _moduleWaypoint setVariable ["BIS_fnc_initModules_disableAutoActivation",false,true]; // @todo check if public is required
                _moduleWaypoint setVariable ["bis_fnc_initmodules_activate",true,true]; // @todo check if public is required

                // waypoint options
                _moduleWaypoint setVariable ["#type",1];
                _moduleWaypoint setVariable ["#capacity",2];
                _moduleWaypoint setVariable ["#usebuilding",true];
                _moduleWaypoint setVariable ["#terminal",false];

                _mrk = createMarker [["wp",_i,diag_frameNo,getpos _moduleWaypoint] joinString "_",getpos _moduleWaypoint];
                _mrk setMarkerType "mil_dot";
                _mrk setMarkerText "wp";
                _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);

                _moduleSpawn synchronizeObjectsAdd [_trg];
                _moduleWaypoint synchronizeObjectsAdd [_trg];

                _check pushBack 0;
            };
        }, 0.2, [_name,_position,_radius,_trg,_count,_step,_offset,_check]] call CBA_fnc_addPerFrameHandler;

        private _mrk = createMarker [CIV_LOCATION_ID(_name),_position];
        _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "Border";
        _mrk setMarkerSize [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist)];
        // [_mrk] call EFUNC(main,setDebugMarker);
    };
} forEach _this;

nil