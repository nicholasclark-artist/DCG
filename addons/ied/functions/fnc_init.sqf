/*
Author:
Nicholas Clark (SENSEI)

Description:
init IED addon

Arguments:
0: position array <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define ACE_TYPES ["IEDUrbanBig_Remote_Mag","IEDUrbanSmall_Remote_Mag"]
#define VANILLA_TYPES ["IEDUrbanBig_F","IEDUrbanSmall_F"]

{
    private _roads = _x nearRoads 200;

    if !(_roads isEqualTo []) then {
        _road = selectRandom _roads;
        private _pos = getPos _road;

        if (!([_pos] call EFUNC(main,inSafezones)) && {isOnRoad _pos}) then {
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
} forEach _this;

// @todo optimize ied checks
if !(CHECK_ADDON_1(ace_explosives)) then {
    [FUNC(handleIED), 2, []] call CBA_fnc_addPerFrameHandler;
};

nil