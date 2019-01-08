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
        // local trigger creates 'Ref to nonnetwork object' spam in log
        private _trg = createTrigger ["EmptyDetector", _position, true];
        _trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
        // @todo delay trigger condition or try dynamicSim
        _trg setTriggerStatements ["this", format ["hint '%1: ON'; diag_log 'IN MOD'",_name], format ["hint '%1: OFF'; diag_log 'OUT MOD'",_name]];  
        _trg setTriggerArea [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist), 0, false]; // @todo test z-dist

        private _count = call {
            if (_type isEqualTo "NameVillage") exitWith {ceil(CIV_VILLAGE_COUNT*GVAR(multiplier))};
            if (_type isEqualTo "NameCity") exitWith {ceil(CIV_CITY_COUNT*GVAR(multiplier))};

            ceil(CIV_CAPITAL_COUNT*GVAR(multiplier));
        };
        
        // needs to be sideLogic to make trigger sync work
        private _grp = createGroup sideLogic;
        private _moduleMain = _grp createUnit ["ModuleCivilianPresence_F", _position, [], 0, "CAN_COLLIDE"];

        MYGRP = _grp;
        MYMOD = _moduleMain;

        _moduleMain setVariable ["BIS_fnc_initModules_disableAutoActivation",false];
        // _moduleMain setVariable ["bis_fnc_initmodules_activate",true];
        _moduleMain setVariable ["#area",[_position,_radius,_radius,0,false,-1]]; // gets passed to inAreaArray @todo test z-dist
        _moduleMain setVariable ["#debug",true];
        _moduleMain setVariable ["#useagents",true];
        _moduleMain setVariable ["#usepanicmode",true];
        _moduleMain setVariable ["#unitcount",_count];
        // _moduleMain setVariable ["#unittypes",EGVAR(main,unitsCiv)];
        _moduleMain setVariable ["#oncreated",{true}];
        _moduleMain setVariable ["#ondeleted",{true}];
        
        if (_name == "Kalithea") then {
            [{
                params ["_args","_idPFH"];
                _args params ["_moduleMain"]; 

                TRACE_1("",_moduleMain getVariable "bis_fnc_initmodules_activate");
            }, 5, _moduleMain] call CBA_fnc_addPerFrameHandler;
        };

        // module synchronizeObjectsAdd [object] 
        _moduleMain synchronizeObjectsAdd [_trg];

        private _step = 360 / _count;
        private _offset = random _step;
        private _check = [];

        [{
            params ["_args","_idPFH"];
            _args params ["_name","_position","_radius","_grp","_trg","_step","_offset","_count","_check"];   

            if (count _check isEqualTo _count) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };

            private _i = (count _check) + 1;
            private _radius = _radius * random [0, 0.4, 0.75];
            private _theta = (_i % 2) * 180 + sin (deg (_step * _i)) * _offset + _step * _i;
            private _positionSpawn = _position getPos [_radius, _theta];

            private _moduleSpawn = _grp createUnit ["ModuleCivilianPresenceUnit_F", _positionSpawn, [], 0, "CAN_COLLIDE"];

            _moduleSpawn setVariable ["BIS_fnc_initModules_disableAutoActivation",false];
            // _moduleSpawn setVariable ["bis_fnc_initmodules_activate",false];
            
            _mrk = createMarker [["spawn",_i,diag_frameNo,getpos _moduleSpawn] joinString "_",getpos _moduleSpawn];
            _mrk setMarkerType "mil_dot";
            _mrk setMarkerText "spawn";

            private _moduleWaypoint = _grp createUnit ["ModuleCivilianPresenceSafeSpot_F", _positionSpawn, [], 0, "CAN_COLLIDE"];

            _moduleWaypoint setVariable ["BIS_fnc_initModules_disableAutoActivation",false];
            // _moduleWaypoint setVariable ["bis_fnc_initmodules_activate",false];
            _moduleWaypoint setVariable ["#type",1];
            _moduleWaypoint setVariable ["#capacity",2];
            _moduleWaypoint setVariable ["#usebuilding",true];
            _moduleWaypoint setVariable ["#terminal",false];

            _mrk = createMarker [["wp",_i,diag_frameNo,getpos _moduleWaypoint] joinString "_",getpos _moduleWaypoint];
            _mrk setMarkerType "mil_dot";
            _mrk setMarkerText "wp";
            _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);

            // module synchronizeObjectsAdd [object]
            _moduleSpawn synchronizeObjectsAdd [_trg];
            _moduleWaypoint synchronizeObjectsAdd [_trg];

            _check pushBack 0;
        }, 0.2, [_name,_position,_radius,_grp,_trg,_step,_offset,_count,_check]] call CBA_fnc_addPerFrameHandler;

        private _mrk = createMarker [CIV_LOCATION_ID(_name),_position];
        _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "Border";
        _mrk setMarkerSize [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist)];
        // [_mrk] call EFUNC(main,setDebugMarker); 
    };
} forEach _this;

nil