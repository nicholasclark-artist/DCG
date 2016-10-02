/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define EXPRESSIONS [["(1 - forest) * (2 + meadow) * (1 - sea) * (1 - houses) * (1 - hills)","meadow"],["(2 + forest) * (1 - sea) * (1 - houses)","forest"],["(2 + hills) * (1 - sea)","hills"],["(2 + houses) * (1 - sea)","houses"]]
#define THRESHOLD ceil(EGVAR(main,range)*0.002)

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		call FUNC(handleVehicle);

		_locations = [];
		_posArray = [];

		{
			if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) then {
				_locations pushBack _x;
			};
			false
		} count EGVAR(main,locations);

		if (CHECK_DEBUG) then {
			private "_mrk";
			{
				_mrk = createMarker [LOCVAR(_x select 0),_x select 1];
				_mrk setMarkerColor "ColorCivilian";
				_mrk setMarkerShape "ELLIPSE";
				_mrk setMarkerBrush "SolidBorder";
				_mrk setMarkerAlpha 0.5;
				_mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
			} forEach _locations;
		};

		[_locations] call FUNC(handleUnit);

		[{
			params ["_args","_idPFH"];
			_args params ["_posArray"];

			if (count _posArray > THRESHOLD) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				if (CHECK_DEBUG) then {
					{
						_pos = _x select 0;
						_mrk = createMarker [format["%1_animal_%2",QUOTE(ADDON),_pos],_pos];
						_mrk setMarkerColor "ColorBlack";
						_mrk setMarkerShape "ELLIPSE";
						_mrk setMarkerBrush "SolidBorder";
						_mrk setMarkerAlpha 0.5;
						_mrk setMarkerSize [GVAR(spawnDist),GVAR(spawnDist)];
					} forEach _posArray;
				};

				[_posArray] call FUNC(handleAnimal);
			};

			_selected = selectRandom EXPRESSIONS;
			_expression = _selected select 0;
			_str = _selected select 1;
			_pos = [EGVAR(main,center),0,EGVAR(main,range)] call EFUNC(main,findPosSafe);
			_ret = selectBestPlaces [_pos,5000,_expression,70,1];
			_pos = _ret select 0 select 0;
			if (!(_ret isEqualTo []) && {!(CHECK_DIST2D(_pos,locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))} && {!(surfaceIsWater _pos)} && {{CHECK_DIST2D(_pos,(_x select 0),GVAR(spawnDist))} count _posArray isEqualTo 0}) then {
				_posArray pushBack [_pos,_str];
			};
		}, 0.1, [_posArray]] call CBA_fnc_addPerFrameHandler;
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;