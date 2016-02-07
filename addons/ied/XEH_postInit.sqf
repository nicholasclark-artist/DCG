/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define DEBUG_IED \
	if (CHECK_DEBUG) then { \
		_mrk = createMarker [format["%1_%2",QUOTE(ADDON),getPosATL _ied],_pos]; \
		_mrk setMarkerType "mil_triangle"; \
		_mrk setMarkerSize [0.5,0.5]; \
		_mrk setMarkerColor "ColorRed"; \
	}

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;
		_type = [];

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if (_data isEqualTo []) then {
			if (CHECK_ADDON_1("ace_explosives")) then {
				_type = ["IEDLandBig_Range_Ammo","IEDLandSmall_Range_Ammo","IEDUrbanBig_Range_Ammo","IEDUrbanSmall_Range_Ammo"];
			} else {
				_type = ["IEDUrbanBig_F","IEDLandBig_F"];
			};

			{
				_y = _x;
				_y deleteAt 2;
				_roads = _y nearRoads 300;
				if !(_roads isEqualTo []) then {
					_road = selectRandom _roads;
					_pos = _road modelToWorld [-3 + (floor random 6),0,0];
					_pos set [2,0];
					if !(CHECK_DIST2D(_pos,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) then {
						_ied = (selectRandom _type) createVehicle _pos;
						GVAR(array) pushBack _ied;
						DEBUG_IED;
					};
				};
			} forEach ([EGVAR(main,center),1500,worldSize,0,0,false,false] call EFUNC(main,findPosGrid));
		} else {
			for "_index" from 0 to count _data - 1 do {
				(_data select _index) params ["_pos","_type"];
				_ied = _type createVehicle _pos;
				GVAR(array) pushBack _ied;
				DEBUG_IED;
			};

		};

		if !(CHECK_ADDON_1("ace_explosives")) then {
			[{
				if (GVAR(array) isEqualTo []) exitWith {
					[_this select 1] call CBA_fnc_removePerFrameHandler;
				};

				{
					_ied = _x;
					_explosions = ["R_TBG32V_F","HelicopterExploSmall"];
					if ({CHECK_DIST2D(_x,_ied,4)} count allPlayers > 0) then {
						(selectRandom _explosions) createVehicle (getPosATL _ied);
						deleteVehicle _ied;
						GVAR(array) deleteAt _forEachIndex;
					};
				} forEach GVAR(array);
			}, 1, []] call CBA_fnc_addPerFrameHandler;
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;