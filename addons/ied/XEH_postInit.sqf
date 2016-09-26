/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST_MIN 750
#define DIST worldSize*0.057 max DIST_MIN
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

/*
		_type = [];

		if (CHECK_ADDON_1("ace_explosives")) then {
			_type = ["ACE_IEDUrbanBig_Range_Ammo","ACE_IEDUrbanSmall_Range_Ammo"];
		} else {
			_type = ["IEDUrbanBig_F"];
		};
*/
		_type = ["IEDUrbanBig_F"];

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if (_data isEqualTo []) then {

			{
				_roads = _x nearRoads DIST_MIN*0.5;

				if !(_roads isEqualTo []) then {
					_road = selectRandom _roads;
					_pos = getPos _road;

					if (!(CHECK_DIST2D(_pos,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) &&
					 {isOnRoad _road} &&
					 {(nearestLocations [_pos, ["NameCityCapital","NameCity","NameVillage"], 500]) isEqualTo []}) then {
						_ied = (selectRandom _type) createVehicle [0,0,0];
						_ied setPos (_pos getPos [5, random 360]);

						GVAR(list) pushBack _ied;
						DEBUG_IED
					};
				};
			} forEach ([EGVAR(main,center),DIST,worldSize,0,0,false,false] call EFUNC(main,findPosGrid));
		} else {
			for "_index" from 0 to count _data - 1 do {
				_ied = (selectRandom _type) createVehicle (_data select _index);
				GVAR(list) pushBack _ied;
				DEBUG_IED
			};
		};

		// if !(CHECK_ADDON_1("ace_explosives")) then {
			[{
				if (GVAR(list) isEqualTo []) exitWith {
					[_this select 1] call CBA_fnc_removePerFrameHandler;
				};

				{
					_ied = _x;
					_near = _ied nearEntities [["Man", "LandVehicle"], 4];
					_near = _near select {isPlayer _x};

					if !(_near isEqualTo []) then {
						_explosions = ["R_TBG32V_F","HelicopterExploSmall"];
						(selectRandom _explosions) createVehicle (getPosATL _ied);
						deleteVehicle _ied;
						GVAR(list) deleteAt _forEachIndex;
					};
				} forEach GVAR(list);
			}, 1, []] call CBA_fnc_addPerFrameHandler;
		// };
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;