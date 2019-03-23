/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian unit spawns using Civilian Presence modules

Arguments:
0: hash key array <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#ifdef DISABLE_COMPILE_CACHE
    #define CIV_PRESENCE_DEBUG true
#else
    #define CIV_PRESENCE_DEBUG false
#endif

// run iterations until location count reached
private _count = count _this;
private _iterations01 = [];

[{
    params ["_args","_idPFH"];
    _args params ["_locations","_count","_iterations01"];

    // get current location params
    (_locations select (count _iterations01)) params ["_name","_position","_radius"];
    
    // exit if all locations handled
    if (count _iterations01 isEqualTo _count) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    // add iteration
    _iterations01 pushBack 0;

    _position = ASLToATL _position;

    // skip location if in blacklist or safezone
    if ((GVAR(blacklist) findIf {(toLower _name) find _x > -1} < 0) && {!([_position] call EFUNC(main,inSafezones))}) then {
        // get houses in area
        private _houses = (_position nearObjects ["House", _radius min 300]) apply {_x buildingPos -1} select {count _x > 0};

        if (count _houses < 2) exitWith {WARNING_3("unsuitable spawn location: %1: %2: %3",_name,_position,count _houses)};
        
        // use houses as basis for unit spawns
        [_houses] call EFUNC(main,shuffle);
        _houses resize (((ceil (count _houses * 0.25)) + 1) min GVAR(unitLimit));

        // debug markers
        private _mrk = createMarker [[QUOTE(PREFIX),_name] joinString "_",_position];
        _mrk setMarkerColor ([CIVILIAN,true] call BIS_fnc_sideColor);
        _mrk setMarkerShape "ELLIPSE";
        _mrk setMarkerBrush "Border";
        _mrk setMarkerSize [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist)];
        [_mrk] call EFUNC(main,setDebugMarker);

        // player detection trigger
        private _trg = createTrigger ["EmptyDetector", _position, true]; // local trigger creates 'Ref to nonnetwork object' spam in log
        _trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
        _trg setTriggerArea [_radius + GVAR(spawnDist), _radius + GVAR(spawnDist), 0, false, CIV_ZDIST];

        // spawn ambient objects when player activates trigger
        private _statement = format [
            "
                [%2,200 min %3,6 min %4,0,thisTrigger] call %1;
            ",
            QFUNC(spawnAmbient),_position,_radius,count _houses
        ];
        
        _trg setTriggerStatements [
            "this",
            _statement,
            format ["['%1',%2] call CBA_fnc_serverEvent",QEGVAR(main,cleanup),GETVAR(thisTrigger,GVAR(ambient),[])]
        ];

        // main module is immediately moved to ambient group, _grp is null after module creation
        private _grp = createGroup sideLogic;
        private _moduleMain = _grp createUnit ["ModuleCivilianPresence_F", DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
        
        // main module does not init sometimes, even with 'BIS_fnc_initModules_disableAutoActivation'
        // force init with 'bis_fnc_initmodules_activate'
        _moduleMain setVariable ["BIS_fnc_initModules_disableAutoActivation",false]; // @todo check if public is required
        // _moduleMain setVariable ["BIS_fnc_initModules_activate",true]; // @todo check if public is required

        // main options
        //@todo fix units getting stuck in floors
        private _onCreated = {
            // spawn position
            // _this setVehiclePosition [_this, [], 0, "NONE"];

            // headless client / cache support
            _this setVariable [QEGVAR(main,HCBlacklist), true];
            _this setVariable ["acex_headless_blacklist", true];

            // behaviors 
            _this setSkill 0.1;

            // animations
            _this setAnimSpeedCoef (0.8 + random 0.2);
        };
        
        _moduleMain setVariable ["#area",[_position,_radius,_radius,0,false,CIV_ZDIST]]; // gets passed to inAreaArray
        _moduleMain setVariable ["#debug",CIV_PRESENCE_DEBUG];
        _moduleMain setVariable ["#useagents",true];
        _moduleMain setVariable ["#usepanicmode",true];
        _moduleMain setVariable ["#unitcount",count _houses]; // @todo adjust unit count based on time of day
        _moduleMain setVariable ["#unittypes",EGVAR(main,unitsCiv)];
        _moduleMain setVariable ["#oncreated",_onCreated];
        _moduleMain setVariable ["#ondeleted",{true}];

        // sync main module to trigger
        _moduleMain synchronizeObjectsAdd [_trg];

        private _iterations02 = [];

        // create spawn and waypoint positions in houses
        [{
            params ["_args","_idPFH"];
            _args params ["_trg","_houses","_iterations02"]; 

            // exit if all houses handled
            if (count _iterations02 isEqualTo count _houses) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };
            
            // _positionHouse = selectRandom (selectRandom _houses);
            _positionHouse = selectRandom (_houses select (count _iterations02));

            // create new groups for these modules, old group is null 

            // create half as many spawn points
            if ((count _iterations02 mod 2) isEqualTo 0) then {
                _grp = createGroup sideLogic;
                _moduleSpawn = _grp createUnit ["ModuleCivilianPresenceUnit_F", _positionHouse, [], 0, "CAN_COLLIDE"];
                
                _moduleSpawn setVariable ["BIS_fnc_initModules_disableAutoActivation",false]; // @todo check if public is required
                // _moduleSpawn setVariable ["BIS_fnc_initModules_activate",true]; // @todo check if public is required

                _moduleSpawn synchronizeObjectsAdd [_trg];
            };
            
            _grp = createGroup sideLogic;
            _moduleWaypoint = _grp createUnit ["ModuleCivilianPresenceSafeSpot_F", _positionHouse, [], 0, "CAN_COLLIDE"];

            _moduleWaypoint setVariable ["BIS_fnc_initModules_disableAutoActivation",false]; // @todo check if public is required
            // _moduleWaypoint setVariable ["BIS_fnc_initModules_activate",true]; // @todo check if public is required

            // waypoint options
            _moduleWaypoint setVariable ["#type",1];
            _moduleWaypoint setVariable ["#capacity",2];
            _moduleWaypoint setVariable ["#usebuilding",true];
            _moduleWaypoint setVariable ["#terminal",false];

            _moduleWaypoint synchronizeObjectsAdd [_trg];            

            _iterations02 pushBack 0;
        }, 0.05, [_trg,_houses,_iterations02]] call CBA_fnc_addPerFrameHandler;
    };
}, 0.2, [_this,_count,_iterations01]] call CBA_fnc_addPerFrameHandler;

nil