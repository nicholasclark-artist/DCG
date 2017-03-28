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
#define DIST_MIN 512
#define DIST worldSize*0.053 max DIST_MIN
#define ACE_TYPES ["IEDUrbanBig_Remote_Mag","IEDUrbanSmall_Remote_Mag"]
#define VANILLA_TYPES ["IEDUrbanBig_F","IEDUrbanSmall_F"]
#define CREATE_IED(POS) \
    if !(CHECK_ADDON_1("ace_explosives")) then { \
        _pos = POS getPos [5, random 360]; \
        _pos set [2,0]; \
        _ied = createSimpleObject [selectRandom VANILLA_TYPES, AGLtoASL _pos]; \
        GVAR(list) pushBack _ied; \
    } else { \
        _pos = POS getPos [5, random 360]; \
        _pos set [2,0]; \
        _ied = [objNull, _pos, random 360, selectRandom ACE_TYPES, "PressurePlate", []] call ACE_Explosives_fnc_placeExplosive; \
        GVAR(list) pushBack _ied; \
    };

params ["_data"];

if (_data isEqualTo []) then {
	{
		private _roads = _x nearRoads 200;

		if !(_roads isEqualTo []) then {
			private _road = selectRandom _roads;
			private _pos = getPos _road;

			if (!(_pos inArea EGVAR(main,baseLocation)) && {isOnRoad _road}) then {
                CREATE_IED(_pos)
			};
		};
		false
	} count EGVAR(main,grid);
} else {
	for "_index" from 0 to count _data - 1 do {
        private _pos = _data select _index;
        CREATE_IED(_pos)
	};
};
