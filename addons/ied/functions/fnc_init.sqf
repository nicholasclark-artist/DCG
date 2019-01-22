/*
Author:
Nicholas Clark (SENSEI)

Description:
init IEDs

Arguments:
0: position array <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

{
    _roads = _x nearRoads 200;

    if !(_roads isEqualTo []) then {
        _road = selectRandom _roads;
        _pos = getPos _road;

        if (!([_pos] call EFUNC(main,inSafezones)) && {isOnRoad _road}) then {
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

nil