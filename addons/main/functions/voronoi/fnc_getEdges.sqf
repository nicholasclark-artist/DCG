/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Entry-point function for generating a voronoi diagram, returns an array of voronoi edges.    
    
    Beware! This function is computionally intensive and may take several seconds to complete, use with care.

    Each edge is an array of:
    [
        EDGE_START, 		- Start position
        EDGE_END, 			- End position
        EDGE_LEFT, 			- Site on the left
        EDGE_RIGHT,			- Site on the right
        EDGE_NEIGHBOUR,		- Internal usage
        EDGE_LINE_F,		- f in the function for the edge's line: y = fx + g
        EDGE_LINE_G,		- g in the function for the edge's line: y = fx + g
        EDGE_DIRECTION		- 2-dimensional direction vector of the line going from start to end, not normalized.
    ]
*/
#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params [
    ["_sites", [], [[]]],
    ["_width", 0],
    ["_height", 0]
];

private _return = [];
if(_width > 0 && _height > 0) then {
    //Initialize pointer storage
    private PTR_MAIN = objNull call FUNC(pointerNewContainer);

    private _edges = [];
    private _vertices = [];
    private _scanlineY = -1;

    private _parabolaTree = NEW_PTR(PARABOLA_NULL);
    private _deletedEvents = [];

    //Insert all site events

    private _eventQueue = (
        _sites apply {
            [_x#POINT_Y, [[_x#0,_x#1], EVENT_TYPE_SITE] call FUNC(newEvent)]
        }
    ) call FUNC(heapNew);
        

#ifdef DO_DEBUG
    diag_log text "GENERATE - Sites:";
    private _queueDebug = +_eventQueue;
    while {_queueDebug call FUNC(heapSize) > 0} do {
        (_queueDebug call FUNC(heapPop)) params ["_key", "_event"];
        diag_log text str (_event#EVENT_POINT);
    };
#endif

    //Iterate through the queue and find edges
    private _i = 0;
    while {_eventQueue call FUNC(heapSize) > 0} do {
        (_eventQueue call FUNC(heapPop)) params ["_key", "_event"];
        _i = _i + 1;
#ifdef DO_DEBUG
        diag_log text format ["GENERATE - Proccessing event #%1", _i];
        diag_log text format ["GENERATE - Next event to proccess: %1", _event];
        diag_log text format [
            "GENERATE - Next event is a %1", 
            ( 
                if(_event#EVENT_TYPE) then {
                    "Site event"
                } else {
                    "Circle event"
                }
            )
        ];
#endif
        //diag_log text format ["GENERATE - Tree size: %1", count _parabolaTree ];
        _scanlineY = _event#EVENT_POINT#POINT_Y; 
        private _deleteIndex = _deletedEvents find _event;
        if(_deleteIndex < 0) then {
            if(_event#EVENT_TYPE) then {
#ifdef DO_DEBUG
                //diag_log text format ["GENERATE - PRE-INSERT Tree size: %1", count _parabolaTree ];
#endif
                [_parabolaTree, _event#EVENT_POINT, _scanlineY, _height, _edges, _vertices, _eventQueue, _deletedEvents] call FUNC(insertParabola);
                
#ifdef DO_DEBUG
                //diag_log text format ["GENERATE - POST-INSERT Tree size: %1", count _parabolaTree ];
                [_parabolaTree, {_this}] call FUNC(printTree);
#endif
            } else {
#ifdef DO_DEBUG
                //diag_log text format ["GENERATE - PRE-REMOVE Tree size: %1", count _parabolaTree ];
#endif
                [_parabolaTree, _event, _scanlineY, _edges, _vertices, _eventQueue, _deletedEvents] call FUNC(removeParabola);
                
#ifdef DO_DEBUG		
                //diag_log text format ["GENERATE - POST-REMOVE Tree size: %1", count _parabolaTree ];		
                [_parabolaTree, {_this}] call FUNC(printTree);
#endif				
            };
        } else {
            //Event deleted
            _deletedEvents deleteAt _deleteIndex;
        };
#ifdef DO_DEBUG
        diag_log text format ["_edges = %1", _edges];
        diag_log text format ["_vertices = %1", _vertices];
        diag_log text format ["_deletedEvents = %1", _deletedEvents];
        diag_log text " ";
        diag_log text "		NEXT EVENT";
        diag_log text " ";
#endif			
    };
    //Finish up edges
    //diag_log text "Finishing up edges...";
    //[_parabolaTree, {_this}] call FUNC(printTree);
    [_parabolaTree, _width, _height, _vertices] call FUNC(finishEdge);

    {
        //Bind half-edges into full edges
        private _neighbourPtr = _x#EDGE_NEIGHBOUR;
        if(!PTR_IS_NULL(_neighbourPtr)) then{
            _x set [EDGE_START, GET_PTR(_neighbourPtr)#EDGE_END];
        };
    } forEach _edges;

    //Bound all edges to the width and height provided, if they are completely outside scrap them.
    private _left = [
        [0, [0,0], []], 
        [_height, [0, _height], []]
    ];
    private _right = [
        [0, [_width,0], []], 
        [_height, [_width, _height], []]
    ];
    private _up = [
        [0, [0,_height], []], 
        [_width, [_width, _height], []]
    ];
    private _down = [
        [0, [0,0], []], 
        [_width, [_width, 0], []]
    ];

    {
        private _edge = _x; 
        [_edge, _width, _height] call FUNC(boundEdge);
        
        //TODO, Detect edges that terminates at bounding border and store them.
        _edge params ["_start", "_end"];
        _start params ["_startX", "_startY"];
        _end params ["_endX", "_endY"];

        if(_startX == 0 OR _endX == 0) then {
            private _outerVertex = [_start, _end] select (_startX != 0);
            _left pushBack [
                _outerVertex#POINT_Y,
                _outerVertex,
                _x
            ];
        };

        if(_startX == _width OR _endX == _width) then {
            private _outerVertex = [_start, _end] select (_startX != _width);
            _right pushBack [
                _outerVertex#POINT_Y,
                _outerVertex,
                _x
            ];
        };

        if(_startY == 0 OR _endY == 0) then {
            private _outerVertex = [_start, _end] select (_startY != 0);
            _down pushBack [
                _outerVertex#POINT_X,
                _outerVertex,
                _x
            ];
        };

        if(_startY == _height OR _endY == _height) then {
            private _outerVertex = [_start, _end] select (_startY != _height);
            _up pushBack [
                _outerVertex#POINT_X,
                _outerVertex,
                _x
            ];
        };
    } forEach _edges;
    
    _left sort true;
    _right sort true;
    _down sort true;
    _up sort true;
    
    //Take edges that terminate at bounding border and pair them up to create a new edge(s) along the outer edge them.
    {
        _x params ["_xValue", "_vertex", "_edge"];
        
        private _nextIndex = _forEachIndex + 1;
        if(_nextIndex < count _left) then {
            (_left#_nextIndex) params ["_nextX", "_nextVertex", "_nextEdge"];
            
            private _site = objNull;
            if(_edge isEqualTo []) then {
                if(_nextEdge isEqualTo []) then {
                    private _sitesByX = _sites apply {[_x#POINT_X, _x]};
                    _sitesByX sort true;
                    _site = _sitesByX#0#1;
                } else {
                    if(_nextEdge#EDGE_DIRECTION#POINT_X > 0) then {
                        _site = _nextEdge#EDGE_LEFT;
                    } else {
                        _site = _nextEdge#EDGE_RIGHT;
                    };
                };
            } else {
                if(_edge#EDGE_DIRECTION#POINT_X > 0) then {
                    _site = _edge#EDGE_RIGHT;
                } else {
                    _site = _edge#EDGE_LEFT;
                };
            };
            
            private _newEdge = [_vertex, _nextVertex, objNull, _site, PTR_NULL, 0, 0, [0,1]];
            _edges pushBack _newEdge;
        };
    } forEach _left;

    {
        _x params ["_xValue", "_vertex", "_edge"];
        
        private _nextIndex = _forEachIndex + 1;
        if(_nextIndex < count _right) then {
            (_right#_nextIndex) params ["_nextX", "_nextVertex", "_nextEdge"];
            
            private _site = objNull;
            if(_edge isEqualTo []) then {
                if(_nextEdge isEqualTo []) then {
                    private _sitesByX = _sites apply {[_x#POINT_X, _x]};
                    _sitesByX sort false;
                    _site = _sitesByX#0#1;
                } else {
                    if(_nextEdge#EDGE_DIRECTION#POINT_X > 0) then {
                        _site = _nextEdge#EDGE_LEFT;
                    } else {
                        _site = _nextEdge#EDGE_RIGHT;
                    };
                };
            } else {
                if(_edge#EDGE_DIRECTION#POINT_X > 0) then {
                    _site = _edge#EDGE_RIGHT;
                } else {
                    _site = _edge#EDGE_LEFT;
                };
            };
            
            private _newEdge = [_vertex, _nextVertex, _site, objNull, PTR_NULL, 0, 0, [0,1]];
            _edges pushBack _newEdge;
        };
    } forEach _right;

    {
        _x params ["_xValue", "_vertex", "_edge"];
        
        private _nextIndex = _forEachIndex + 1;
        if(_nextIndex < count _down) then {
            (_down#_nextIndex) params ["_nextX", "_nextVertex", "_nextEdge"];
            
            private _site = objNull;
            if(_edge isEqualTo []) then {
                if(_nextEdge isEqualTo []) then {
                    private _sitesByY = _sites apply {[_x#POINT_Y, _x]};
                    _sitesByY sort true;
                    _site = _sitesByY#0#1;
                } else {
                    if(_nextEdge#EDGE_DIRECTION#POINT_Y > 0) then {
                        _site = _nextEdge#EDGE_RIGHT;
                    } else {
                        _site = _nextEdge#EDGE_LEFT;
                    };
                };
            } else {
                if(_edge#EDGE_DIRECTION#POINT_Y > 0) then {
                    _site = _edge#EDGE_LEFT;
                } else {
                    _site = _edge#EDGE_RIGHT;
                };
            };
            
            private _newEdge = [_vertex, _nextVertex, _site, objNull, PTR_NULL, 0, 0, [0,1]];
            _edges pushBack _newEdge;
        };
    } forEach _down;

    {
        _x params ["_xValue", "_vertex", "_edge"];
        
        private _nextIndex = _forEachIndex + 1;
        if(_nextIndex < count _up) then {
            (_up#_nextIndex) params ["_nextX", "_nextVertex", "_nextEdge"];
                        
            private _site = objNull;
            if(_edge isEqualTo []) then {
                if(_nextEdge isEqualTo []) then {
                    private _sitesByY = _sites apply {[_x#POINT_Y, _x]};
                    _sitesByY sort false;
                    _site = _sitesByY#0#1;
                } else {
                    if(_nextEdge#EDGE_DIRECTION#POINT_Y > 0) then {
                        _site = _nextEdge#EDGE_RIGHT;
                    } else {
                        _site = _nextEdge#EDGE_LEFT;
                    };
                };
            } else {
                if(_edge#EDGE_DIRECTION#POINT_Y > 0) then {
                    _site = _edge#EDGE_LEFT;
                } else {
                    _site = _edge#EDGE_RIGHT;
                };
            };
            
            private _newEdge = [_vertex, _nextVertex, objNull, _site, PTR_NULL, 0, 0, [0,1]];
            _edges pushBack _newEdge;
        };
    } forEach _up;

    _return = _edges select {!isNil "_x"};
} else {
    ["GENERATE - Width and Height must both be greater than 0."] call BIS_fnc_error;
};
_return