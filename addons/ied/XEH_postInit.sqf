/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST_MIN 750
#define DIST worldSize*0.053 max DIST_MIN
#define DEBUG_IED \
	if (CHECK_DEBUG) then { \
		_mrk = createMarker [format["%1_%2",QUOTE(ADDON),getPosATL _ied],getPosATL _ied]; \
		_mrk setMarkerType "mil_triangle"; \
		_mrk setMarkerSize [0.5,0.5]; \
		_mrk setMarkerColor "ColorRed"; \
	};

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		_type = [];

		if (CHECK_ADDON_1("ace_explosives")) then {
			_type = ["ACE_IEDUrbanBig_Range_Ammo","ACE_IEDUrbanSmall_Range_Ammo"];
		} else {
			_type = ["IEDUrbanBig_F"];
		};

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if (_data isEqualTo []) then {
			{
				_pos = _x getPos [DIST_MIN,random 360];
				_roads = _pos nearRoads 400;
				if !(_roads isEqualTo []) then {
					_road = selectRandom _roads;
					_pos = getPos _road;
					if (!(CHECK_DIST2D(_pos,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) &&
					 {isOnRoad _road} &&
					 {(nearestLocations [_pos, ["NameCityCapital","NameCity","NameVillage"], 500]) isEqualTo []} &&
					 {{CHECK_DIST2D(_pos,getpos _x,500)} count GVAR(array) isEqualTo 0}) then {
						_ied = (selectRandom _type) createVehicle [0,0,0];
						_ied setPos (_pos getPos [6, random 360]);
						GVAR(array) pushBack _ied;
						DEBUG_IED
					};
				};
			} forEach ([EGVAR(main,center),DIST,worldSize,0,0,false,false] call EFUNC(main,findPosGrid));
		} else {
			for "_index" from 0 to count _data - 1 do {
				_ied = (selectRandom _type) createVehicle (_data select _index);
				GVAR(array) pushBack _ied;
				DEBUG_IED
			};
		};

		if !(CHECK_ADDON_1("ace_explosives")) then {
			[{
				if (GVAR(array) isEqualTo []) exitWith {
					[_this select 1] call CBA_fnc_removePerFrameHandler;
				};

				{
					_ied = _x;
					if ({CHECK_DIST2D(_x,_ied,4)} count allPlayers > 0) then {
						_explosions = ["R_TBG32V_F","HelicopterExploSmall"];
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