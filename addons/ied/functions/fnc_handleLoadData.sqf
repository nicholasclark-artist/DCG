/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:
0: data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST_MIN 750
#define DIST worldSize*0.057 max DIST_MIN
#define TYPE_IED "IEDUrbanBig_F"
#define DEBUG_IED \
	_mrk = createMarker [format["%1_%2",QUOTE(ADDON),getPosATL _ied],getPosATL _ied]; \
	_mrk setMarkerType "mil_triangle"; \
	_mrk setMarkerSize [0.5,0.5]; \
	_mrk setMarkerColor "ColorRed"; \
	[_mrk] call EFUNC(main,setDebugMarker)

params ["_data"];

if (_data isEqualTo []) then {
	{
		_roads = _x nearRoads DIST_MIN*0.5;

		if !(_roads isEqualTo []) then {
			_road = selectRandom _roads;
			_pos = getPos _road;

			if (!(CHECK_DIST2D(_pos,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) && {isOnRoad _road} && {(nearestLocations [_pos, ["NameCityCapital","NameCity","NameVillage"], 500]) isEqualTo []}) then {
				_ied = TYPE_IED createVehicle [0,0,0];
				_ied setPos (_pos getPos [5, random 360]);
				GVAR(list) pushBack _ied;
				DEBUG_IED;
			};
		};
		false
	} count ([EGVAR(main,center),DIST,worldSize,0,-1,false,false] call EFUNC(main,findPosGrid));
} else {
	for "_index" from 0 to count _data - 1 do {
		_ied = TYPE_IED createVehicle (_data select _index);
		GVAR(list) pushBack _ied;
		DEBUG_IED;
	};
};