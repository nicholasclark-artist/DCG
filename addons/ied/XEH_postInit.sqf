/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define ACE_TYPES ["IEDUrbanBig_Remote_Mag","IEDUrbanSmall_Remote_Mag"]
#define VANILLA_TYPES ["IEDUrbanBig_F","IEDUrbanSmall_F"]

POSTINIT;

[
    {MAIN_ADDON && {CHECK_INGAME}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {
            LOG(MSG_EXIT);
        };

        // create ieds 
        {
            _roads = _x nearRoads 200;

            if !(_roads isEqualTo []) then {
                _road = selectRandom _roads;
                _pos = getPos _road;

                if (!([_pos] call EFUNC(safezone,inAreaAll)) && {isOnRoad _road}) then {
                    _pos = _pos getPos [5, random 360];
                    _pos set [2,0];

                    // let ace handle ied if enabled
                    _ied = if (CHECK_ADDON_1(ace_explosives)) then {
                        [objNull, _pos, random 360, selectRandom ACE_TYPES, "PressurePlate", []] call ACE_Explosives_fnc_placeExplosive;
                    } else {
                        createSimpleObject [selectRandom VANILLA_TYPES, AGLtoASL _pos];
                    };

                    _mrk = createMarker [format["%1_%2",QUOTE(ADDON),_forEachIndex],getPos _ied];
                    _mrk setMarkerType "mil_triangle";
                    _mrk setMarkerSize [0.5,0.5];
                    _mrk setMarkerColor "ColorRed";
                    [_mrk] call EFUNC(main,setDebugMarker);

                    GVAR(list) pushBack _ied;
                };
            };
        } forEach EGVAR(main,grid);

        if !(CHECK_ADDON_1(ace_explosives)) then {
            [FUNC(handleIED), 1, []] call CBA_fnc_addPerFrameHandler;
        };
    }
] call CBA_fnc_waitUntilAndExecute;