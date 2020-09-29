#define COMPONENT transport
#define COMPONENT_PRETTY Transport

#include "\d\dcg\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define TR_STR_EXFIL "Open your map and select a LZ for extraction."
#define TR_STR_INFIL "Select a LZ for insertion."
#define TR_STR_CLOSE "Insertion LZ is too close to extraction LZ."
#define TR_STR_NOTLAND "LZ must be on land."
#define TR_STR_BADTERRAIN "Unsuitable terrain,select another LZ."
#define TR_STR_CANCEL "Transport request canceled."
#define TR_STR_GETIN "Signal take off when ready."
#define TR_STR_KILLED "Transport destroyed enroute to LZ!"
#define TR_STR_ENROUTE "Transport enroute."

#define MRK_INFIL(VAR) ([VAR,"infil"] joinString "_")
#define MRK_EXFIL(VAR) ([VAR,"exfil"] joinString "_")

#define TR_SPAWN_DIST 4000
#define TR_IDLE_TIME 300
#define TR_CHECKDIST 15

#define TR_STATE_WAITING "WAITING"
#define TR_STATE_READY "READY"
#define TR_STATE_NOTREADY "NOT READY"

#define TR_COOLDOWN(REQUESTOR) \
    {GVAR(status) = TR_STATE_WAITING} remoteExecCall [QUOTE(call),_this,false]; \
    [ \
        { \
            {GVAR(status) = TR_STATE_READY} remoteExecCall [QUOTE(call),_this,false]; \
            GVAR(count) = GVAR(count) - 1; \
            publicVariable QGVAR(count); \
        }, \
        (REQUESTOR), \
        GVAR(cooldown) \
    ] call CBA_fnc_waitAndExecute
#define TR_EXFIL(TRANSPORT) \
    [ \
        TRANSPORT, \
        TRANSPORT getVariable QGVAR(exfil), \
        { \
            [ \
                { \
                    if !(_this getVariable [QGVAR(signal),-1] isEqualTo 1) then { \
                        {if !(group _x isEqualTo (group (driver _this))) then {moveOut _x}} forEach (crew _this); \
                        [QEGVAR(main,cleanup),_this] call CBA_fnc_serverEvent; \
                        _this move DEFAULT_POS; \
                        _this setVariable [QGVAR(status),TR_STATE_WAITING,false]; \
                    }; \
                }, \
                _this, \
                TR_IDLE_TIME \
            ] call CBA_fnc_waitAndExecute; \
        }, \
        TRANSPORT \
    ] call EFUNC(main,landAt)
#define TR_INFIL(TRANSPORT) \
    [ \
        {_this getVariable [QGVAR(signal),-1] isEqualTo 1}, \
        { \
            _this removeAllEventHandlers "GetIn"; \
            [ \
                _this, \
                _this getVariable QGVAR(infil), \
                { \
                    [ \
                        { \
                            {if !(_x isEqualTo (driver _this)) then {moveOut _x}} forEach (crew _this); \
                            [QEGVAR(main,cleanup),_this] call CBA_fnc_serverEvent; \
                            _this move DEFAULT_POS; \
                            _this setVariable [QGVAR(status),TR_STATE_WAITING,false]; \
                        }, \
                        _this, \
                        10 \
                    ] call CBA_fnc_waitAndExecute; \
                }, \
                _this \
            ] call EFUNC(main,landAt); \
        },\
        TRANSPORT \
    ] call CBA_fnc_waitUntilAndExecute

#define TR_REQUEST_NAME "Request Transport"
#define TR_REQUEST_CHILD call FUNC(getChildren)
#define TR_REQUEST_COND call FUNC(canCallTransport)

#define TR_SIGNAL_NAME "Signal Take Off"
#define TR_SIGNAL_STATEMENT (objectParent player) setVariable [QGVAR(signal),1,true]
#define TR_SIGNAL_COND !(isNull objectParent player) && {((objectParent player) getVariable [QGVAR(signal),-1]) isEqualTo 0}
