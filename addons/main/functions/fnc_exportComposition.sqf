/*
Author:
Nicholas Clark (SENSEI)

Description:
export composition data from 3DEN,must be used in VR map

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define CONFIG (configfile >> QGVARMAIN(compositions))
#define PRINT_MSG(MSG) titleText [MSG,"PLAIN"]
#define ATTRIBUTE_SNAP(ENTITY) (parseNumber ((ENTITY get3DENAttribute QGVAR(snap)) select 0))
#define ATTRIBUTE_VECTORUP(ENTITY) (parseNumber ((ENTITY get3DENAttribute QGVAR(vectorUp)) select 0))
#define ATTRIBUTE_SIMPLE(ENTITY) (parseNumber ((ENTITY get3DENAttribute "objectIsSimple") select 0))
#define PIVOT_CHECK(ENTITY) (typeOf ENTITY isEqualTo "Sign_Arrow_F")
#define NODE_CHECK(ENTITY) (typeOf ENTITY isEqualTo "CBA_BuildingPos")
#define NODE_MAXDIST 51
#define GET_INS(ENTITY) (["",typeOf ((lineIntersectsSurfaces [getPosASL ENTITY,(getPosASL ENTITY) vectorAdd [0,0,(((getPosATL ENTITY) select 2) + 0.1) * -1],ENTITY,objNull,true,1,"GEOM","NONE"]) select 0 select 2)] select (ATTRIBUTE_SNAP(ENTITY) isEqualTo 1))
#define GET_POS_RELATIVE(ENTITY) (_pivot worldToModel (getPosATL ENTITY))
#define GET_DIR_OFFSET(ENTITY) (((getDir ENTITY) - (getDir _pivot)) mod 360)
#define GET_DATA(ENTITY) _composition pushBack [typeOf ENTITY,str GET_POS_RELATIVE(ENTITY),str ((getPosATL ENTITY) select 2),GET_INS(ENTITY),str GET_DIR_OFFSET(ENTITY),ATTRIBUTE_VECTORUP(ENTITY),ATTRIBUTE_SIMPLE(ENTITY)]

// data precision
toFixed 4;

// reset ui vars
uiNamespace setVariable [QGVAR(compExportDisplay),displayNull];
GVAR(compExportSel) = "";

if !(COMPARE_STR(worldName,"VR")) exitWith {
    PRINT_MSG("you must export compositions from VR map");
};

private _composition = [];
private _nodes = [];
private _selected = get3DENSelected "object";
private _r = 0;
private _pivot = objNull;
private _id = "";
private _br = toString [13,10];
private _tab = "    ";

// get composition pivot
{
    if (PIVOT_CHECK(_x)) exitWith {
        _pivot = _x;
        // make sure pivot is snapped to terrain
        _pivot setPosATL [(getPosATL _pivot) select 0,(getPosATL _pivot) select 1,0];
        _pivot setVectorDirAndUp [[0,1,0],[0,0,1]];

        // get composition id,ids may overlap if compositions are exported from multiple missions
        _id = get3DENEntityID _pivot;
    };
} forEach _selected;

if (isNull _pivot) exitWith {
    PRINT_MSG("cannot export composition while pivot is undefined");
};

// get nodes (safe areas)
{
    if (NODE_CHECK(_x)) then {
        private _radius = 0;

        for "_i" from 1 to NODE_MAXDIST step 1 do {
            private _near = nearestObjects [_x,[],_i];

            if (count _near > 1) exitWith {
                // we only care about the first nearest object (the node is element 0)
                _near = _near select 1;

                // node radius will default to 0 if in another object's bounding box
                if !([_x,_near] call FUNC(inBoundingBox)) then {
                    // get radius to nearest bounding box vertex
                    _radius = _x distance2D ([_near,_x] call FUNC(getBoundingBoxCorners));
                };
            };

            // use max radius if no near objects
            if (_i isEqualTo NODE_MAXDIST) exitWith {
                _radius = NODE_MAXDIST;
            };
        };

        // save node
        _x setVectorDirAndUp [[0,1,0],[0,0,1]];
        _nodes pushBack [str GET_POS_RELATIVE(_x),str (0 max ((getPosATL _x) select 2)),str _radius];
    };
} forEach _selected;

TRACE_1("",_nodes);
// save object data
{
    if (!NODE_CHECK(_x) && {!PIVOT_CHECK(_x)} && {!(_x isKindOf "Man")}) then {
        // save raw z value separately as model-space z value is inaccurate
        // GET_INS will cause error if snap is true while no intersection is detected
        GET_DATA(_x);
        // update max radius
        _r = (ceil ((getPosASL _x) vectorDistance (getPosASL _pivot))) max _r;
    };
} forEach _selected;

// create type listbox
[_br,_tab,_composition,_nodes,_r,_id] spawn {
    params ["_br","_tab","_composition","_nodes","_r","_id"];

    closeDialog 2;

    private _display = findDisplay 313 createDisplay "RscDisplayEmpty";
    uiNamespace setVariable [QGVAR(compExportDisplay),_display];

    private _title = _display ctrlCreate ["RscText",100];
    _title ctrlSetPosition [0.7,0.3,0.5,0.05];
    _title ctrlCommit 0;
    _title ctrlSetText "Select Composition Type";

    private _dropdown = _display ctrlCreate ["CtrlCombo",101];
    _dropdown ctrlSetPosition [0.7,0.37,0.5,0.05];
    _dropdown ctrlCommit 0;

    private ["_name","_item","_cfgName"];

    for "_i" from 0 to (count CONFIG) - 1 do {
        _name = configName (CONFIG select _i);
        _item = _dropdown lbAdd _name;
        _dropdown lbSetData [_item,_name];
    };

    _dropdown ctrlAddEventHandler ["LBSelChanged",{
        params ["_control","_selectedIndex"];

        (uiNamespace getVariable [QGVAR(compExportDisplay),displayNull]) closeDisplay 1;
        GVAR(compExportSel) = _control lbData (lbCurSel _control);
    }];

    waitUntil {isNull _display};

    // compile class text and copy to clipboard
    for "_i" from 0 to (count CONFIG) - 1 do {
        _cfgName = configName (CONFIG select _i);
        if (COMPARE_STR(GVAR(compExportSel),_cfgName)) exitWith {
            private _className = format ["GVARMAIN(DOUBLES(%1,%2))",_cfgName,_id];
            private _compiledEntry = [
                format ["class %3 {%1%2radius = %4;%1%2nodes = ",_br,_tab,_className,_r],
                str (str _nodes),
                format [";%1%2objects = ",_br,_tab],
                str (str _composition),
                format [";%2%1};",_br,_tab]
            ] joinString "";

            copyToClipboard _compiledEntry;

            private _msg = format ["Exporting %1 composition (%2) to clipboard: radius: %3, nodes: %4",_cfgName,_id,_r,count _nodes];
            PRINT_MSG(_msg);
        };
    };
};

nil