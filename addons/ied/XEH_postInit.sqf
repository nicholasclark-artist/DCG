/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define TYPE_EXP ["R_TBG32V_F","HelicopterExploSmall"]

if !(isMultiplayer) exitWith {};

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {};
       
        _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);
        [_data] call FUNC(handleLoadData);

        if !(CHECK_ADDON_1("ace_explosives")) then {
            [FUNC(handleIED), 1, []] call CBA_fnc_addPerFrameHandler;
        };

        {
            _mrk = createMarker [format["%1_%2",QUOTE(ADDON),_forEachIndex],getPos _x];
            _mrk setMarkerType "mil_triangle";
            _mrk setMarkerSize [0.5,0.5];
            _mrk setMarkerColor "ColorRed";
            [_mrk] call EFUNC(main,setDebugMarker);
        } forEach GVAR(list);
    }
] call CBA_fnc_waitUntilAndExecute;


