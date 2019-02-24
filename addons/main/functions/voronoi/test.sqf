// execVM "\d\dcg\addons\main\functions\voronoi\test.sqf"

diag_log "VORONOI TEST";

if !(isMultiplayer) exitWith {
    diag_log "EXIT - VORONOI TEST";
};

TEST_edgesToDraw = [];

[] spawn {
    params ["_t", "_e", "_s"];
    
    #define MAIN_MAP (findDisplay 12 displayCtrl 51)
    waitUntil { !isNull MAIN_MAP };
    MAIN_MAP ctrlAddEventHandler [
        "Draw",
        {
            TEST_edgesToDraw apply {
                _x params ["_start", "_end"];

                private _d = _end getDir _start;
                private _l = 0.5*(_start distance2D _end);
                private _a1 = _end getPos [_l min 75, _d+25];
                private _a2 = _end getPos [_l min 75, _d-25];

                (_this select 0) drawLine [
                    _start,
                    _end,
                    [1,0,0,1]
                ];
                (_this select 0) drawLine [
                    _end,
                    _a1,
                    [1,0,0,1]
                ];
                (_this select 0) drawLine [
                    _end,
                    _a2,
                    [1,0,0,1]
                ];
                (_this select 0) drawLine [
                    _a1,
                    _a2,
                    [1,0,0,1]
                ];
            };
        }
    ];
};

waitUntil {player == player};
player addAction [
    "Clear sites",
    {
        TEST_sites = [];
        TEST_edgesToDraw = [];
    }
];

TEST_sites = [];

onMapSingleClick {
    if(_shift) then {
        _pos spawn {
            // TEST_sites pushBack _this;

            TEST_sites = [];
            
            [dcg_main_locations,{
                TEST_sites pushBack (_value#0);
            }] call CBA_fnc_hashEachPair;

            TEST_sites =+ TEST_sites;
            
            {
                _x resize 2;
            } forEach TEST_sites;

            private _dT = diag_tickTime;
            //Get voronoi edges
            private _voronoiEdges = [TEST_sites, worldSize, worldSize] call dcg_main_fnc_getEdges;
            private _execTime = diag_tickTime - _dT;

            TEST_edgesToDraw = _voronoiEdges;

            hint parseText format [
                [
                    "<t align='left'># of sites: </t><t align='right'>%1</t>",
                    "<t align='left'># of edges: </t><t align='right'>%2</t>",
                    "<t align='left'>Execution time: </t><t align='right'>%3</t>"
                ] joinString "<br/>", 
                count TEST_sites, 
                count _voronoiEdges,
                _execTime
            ];
        };
    };

    _shift;
};