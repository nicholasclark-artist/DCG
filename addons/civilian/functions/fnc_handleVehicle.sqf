/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian vehicle spawns

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define BUFFER 50

GVAR(drivers) =  GVAR(drivers) select {!isNull _x};

if (count GVAR(drivers) > ceil GVAR(vehLimit)) exitWith {
    WARNING("vehicle limit reached");
};

private _player = call EFUNC(main,getTargetPlayer);

if (isNull _player) exitWith {
    WARNING("cannot find target player for civilian driver");
};

private _roadPositions = [getPos _player,3000] call EFUNC(main,findPosDriveby);

if (_roadPositions isEqualTo []) exitWith {
    WARNING("cannot find road positions for civilian driver");
};

if (
    ([_roadPositions select 0,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo [] &&
    {([_roadPositions select 2,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []}
) then {
    _roadPositions call FUNC(spawnVehicle);
    // {
    //     deleteMarker _x
    // } forEach TEST_MARKERS;
    // TEST_MARKERS = [];
    // {
    //     _m = createMarker [[diag_frameNo,_forEachIndex] joinString "",_x];
    //     _m setMarkerType "mil_dot";
    //     _m setMarkerText str _forEachIndex;
    //     TEST_MARKERS pushBack _m;
    // } forEach _roadPositions;
};

nil