/*
Author:
Nicholas Clark (SENSEI)

Description:
question nearby unit

Arguments:
0: player <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define QVAR QUOTE(DOUBLES(ADDON,questioned))
#define IEDVAR QUOTE(DOUBLES(ADDON,iedMarked))
#define COOLDOWN 300
#define SEND_MSG(MSG) [MSG] remoteExecCall [QEFUNC(main,displayText), _player, false]

params [
    "_player",
    "_unit"
];

if (diag_tickTime < (_unit getVariable [QVAR,COOLDOWN * -1]) + COOLDOWN) exitWith {
	_text = [
		format ["%1 was questioned recently.",name _unit],
		format ["You questioned %1 not too long ago.",name _unit],
		format ["%1 already spoke to you.",name _unit]
	];
	SEND_MSG(selectRandom _text);
};

_unit setVariable [QVAR,diag_tickTime,true];

private _text = [
	format ["%1 doesn't have any relevant information.",name _unit],
	format ["%1 doesn't know anything.",name _unit],
	format ["%1 isn't interested in talking right now.",name _unit]
];

if (random 1 < AV_CHANCE(getpos _player)) then {
	private _type = floor random 2;

	if (_type isEqualTo 0) exitWith {
		_near = _unit nearEntities [["Man","LandVehicle","Ship"], 1200];
		_near = _near select {!(side _x isEqualTo EGVAR(main,playerSide)) && {!(side _x isEqualTo CIVILIAN)}};

		if (_near isEqualTo []) exitWith {
			SEND_MSG(selectRandom _text);
		};

		private _enemy = selectRandom _near;
		private _area = nearestLocations [getposATL _enemy, ["NameCityCapital","NameCity","NameVillage"], 1000];

		if (_area isEqualTo []) exitWith {
			SEND_MSG(selectRandom _text);
		};

		_text = [
			format ["%1 saw soldiers around %2 not too long ago.",name _unit,text (_area select 0)],
			format ["%1 heard about soldiers moving through %2 not long ago.",name _unit,text (_area select 0)]
		];

		SEND_MSG(selectRandom _text);
	};
	if (_type isEqualTo 1) exitWith {
		if (CHECK_ADDON_2(ied)) then {
			{
				if (CHECK_VECTORDIST(getPosASL _x,getPosASL _unit,1200) && {!(_x getVariable [IEDVAR,false])}) exitWith {
					_text = [
						format ["%1 spotted a roadside IED a few hours ago. He marked it on your map.",name _unit],
						format ["%1 saw someone burying an explosive device a while ago. He marked the position on your map.",name _unit]
					];

					_x setVariable [IEDVAR,true];

					_mrk = createMarker [format ["ied_%1", diag_tickTime], getpos _x];
					_mrk setMarkerType "hd_warning";
					_mrk setMarkerText format ["IED"];
					_mrk setMarkerSize [0.75,0.75];
					_mrk setMarkerColor "ColorRed";
				};
			} forEach (EGVAR(ied,list));
		};
		SEND_MSG(selectRandom _text);
	};

	SEND_MSG(selectRandom _text);
} else {
	SEND_MSG(selectRandom _text);
};
