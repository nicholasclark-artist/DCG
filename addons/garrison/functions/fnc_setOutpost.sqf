/*
Author:
Nicholas Clark (SENSEI)

Description:
set outpost locations

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define ITERATIONS 100
#define OP_DIST 500

private _outposts = [];

[GVAR(areas),{
    private _pos = [];

    // get terrain type and outpost position
    for "_i" from 0 to ITERATIONS do {
        scopeName "loop";

        TRACE_1("",_i);

        private _type = selectRandom ["meadow", "hill", "forest"];

        _pos = [getPos _value, _value getVariable [QGVAR(polygonRadius), 0], _type, 1, 0, true] call EFUNC(main,findPosTerrain);

        if !(_pos isEqualTo []) then {
            // check if position in polygon and check distance to other outposts and comms array
            private _distCheck = true;

            {
                if (CHECK_DIST2D(_pos,getPos (_x select 1),OP_DIST)) exitWith {_distCheck = false};
            } forEach _outposts;

            if (CHECK_DIST2D(_pos,getPos GVAR(commsArray),OP_DIST)) then {_distCheck = false};

            if (_distCheck && {_pos inPolygon (_value getVariable [QGVAR(polygon),[]])}) then {
                // create outpost location
                _location = createLocation ["Invisible",_pos,1,1];
                
                // select outpost alias
                private _alias = call EFUNC(main,getAlias);

                // try getting a new alias if same as AO
                if (COMPARE_STR(_alias, name _value)) then {
                    _alias = call EFUNC(main,getAlias);
                }; 

                _location setText _alias;

                // setvars
                _location setVariable [QGVAR(terrain),_type];
                _location setVariable [QGVAR(radius),100]; // will be adjusted based on composition size
                _location setVariable [QGVAR(unitCount),OP_UNITCOUNT]; // intended unit count, may differ
                _location setVariable [QGVAR(unitCountCurrent),OP_UNITCOUNT]; // actual unit count
                _location setVariable [QGVAR(officer),objNull];
                // _location setVariable [QGVAR(alias),_alias];
                _location setVariable [QGVAR(onKilled),{
                    private _count = _this getVariable [QGVAR(unitCountCurrent),-1];
                    _this setVariable [QGVAR(unitCountCurrent),_count - 1];
                }];

                // setup hash
                _outposts pushBack [_key,_location];

                breakOut "loop";
            };
        };
    };
}] call CBA_fnc_hashEachPair;

// create outpost hash
GVAR(outposts) = [_outposts,[]] call CBA_fnc_hashCreate;

// return true if all outpost locations set
count ([GVAR(outposts)] call CBA_fnc_hashKeys) isEqualTo OP_COUNT