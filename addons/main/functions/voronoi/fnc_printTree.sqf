/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Prints the given tree, by default only prints pointer names but printing behaviour can be changed through the return value of _code.
    Inside _code parameter _this refers to the pointer to the given element that is currently being printed.
*/

#include "script_component.hpp"

#ifdef DO_DEBUG
diag_log text format ["Func: %1", _fnc_scriptName];
diag_log text format ["Called by: %1", _fnc_scriptNameParent];
#endif

params [
    ["_rootPtr", "", [""]],
    ["_code", {_this}, [{}]]
];

#define LOG_2(x) (log(x)/log 2)

//Parse tree into levels matrix via breadth-first traverse
private _levels = [];
private _currentLevel = 0;
private _currentArray = [];
private _visitQueue = [_rootPtr];
private _nodesVisited = 0;
while {count _visitQueue > 0} do {
    //Visit next
    private _curPtr = _visitQueue deleteAt 0;
    if(!PTR_IS_NULL(_curPtr)) then {
        //Check if we reached a new level
        _nodesVisited = _nodesVisited + 1;
        private _nextLevel = floor LOG_2(_nodesVisited);
        if(_nextLevel != _currentLevel) then {
            _currentLevel = _nextLevel;
            _levels pushBack _currentArray;
            _currentArray = [];
        };

        private _nodeStr = _curPtr call _code;
        if(isNil "_nodeStr") then {_nodeStr = "x"};

        _currentArray pushBack _nodeStr;

        //Queue children
        private _current = GET_PTR(_curPtr);
        _visitQueue pushBack (_current#PARABOLA_LEFT);
        _visitQueue pushBack (_current#PARABOLA_RIGHT);
    };
};
_levels pushBack _currentArray;

//Assume a perfect binary tree (even if it isn't)
private _treeHeight = floor LOG_2(_nodesVisited);
private _treeL = 2^_treeHeight;

//Print header
diag_log text "Output:";

//Print top separator
private _str = "";
for "_i" from 1 to 2*_treeL do {
    _str = _str + "=";
};
diag_log text _str;

//Print levels
{
    private _level = _x;
    private _n = 2^_forEachIndex;

    //Get the total number of spaces to accompany each node
    private _spacesPerChild = (2*_treeL+1 - _n)/(_n + 1);
    private _spacer = "";
    for "_i" from 1 to _spacesPerChild do {
        _spacer = _spacer + "   ";
    };

    private _str = format ["%1 | %2", _forEachIndex, _spacer];
    {
        _str = _str + _x + _spacer;
    } forEach _level;

    diag_log text _str;
} forEach _levels;

//Print bottow separator
private _str = "";
for "_i" from 1 to 2*_treeL do {
    _str = _str + "=";
};
diag_log text _str;