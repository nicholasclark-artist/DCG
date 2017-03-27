#define COMPONENT transport
#define COMPONENT_PRETTY Transport

#include "\d\dcg\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#include "\d\dcg\addons\main\script_macros.hpp"

#define PVEH_REQUEST QGVAR(request)

#define VAR_SIGNAL QUOTE(DOUBLES(ADDON,signal))
#define VAR_STUCKPOS QUOTE(DOUBLES(ADDON,stuckPos))
#define VAR_HELIPAD_EXFIL QUOTE(DOUBLES(ADDON,exfil))
#define VAR_HELIPAD_INFIL QUOTE(DOUBLES(ADDON,infil))
#define VAR_REQUESTOR QUOTE(DOUBLES(ADDON,requestor))
#define VAR_MARKER_EXFIL QUOTE(DOUBLES(ADDON,exfilMrk))
#define VAR_MARKER_INFIL QUOTE(DOUBLES(ADDON,infilMrk))

#define STR_EXFIL "Open your map and select a LZ for extraction."
#define STR_INFIL "Select a LZ for insertion."
#define STR_CLOSE "Insertion LZ is too close to extraction LZ."
#define STR_NOTLAND "LZ must be on land."
#define STR_BADTERRAIN "Unsuitable terrain, select another LZ."
#define STR_CANCEL "Transport request canceled."
#define STR_GETIN "Signal take off when ready."
#define STR_KILLED "Transport destroyed enroute to LZ!"
#define STR_ENROUTE "Transport enroute."

#define MRK_INFIL(VAR) ([VAR,"infil"] joinString "_")
#define MRK_EXFIL(VAR) ([VAR,"exfil"] joinString "_")

#define EH_INFIL ([QUOTE(ADDON),"infilLZ"] joinString "_")
#define EH_EXFIL ([QUOTE(ADDON),"exfilLZ"] joinString "_")

#define TR_SPAWN_DIST 4000
#define TR_IDLE_TIME 300
#define TR_CHECKDIST 15
#define TR_WAITING "WAITING"
#define TR_READY "READY"
#define TR_NOTREADY "NOT READY"
#define TR_COOLDOWN(REQUESTOR) \
	[ \
		{ \
            {GVAR(status) = TR_READY} remoteExecCall [QUOTE(BIS_fnc_call),_this,false]; \
			GVAR(count) = GVAR(count) - 1; \
			publicVariable QGVAR(count); \
		}, \
		(REQUESTOR), \
		GVAR(cooldown) \
	] call CBA_fnc_waitAndExecute
#define TR_EXFIL(TRANSPORT) \
    [ \
        TRANSPORT, \
        TRANSPORT getVariable VAR_HELIPAD_EXFIL, \
        "GET IN", \
        { \
            [ \
    			{ \
    				if !(_this getVariable [VAR_SIGNAL,-1] isEqualTo 1) then { \
    					{if !(_x isEqualTo (driver _this)) then {moveOut _x}} forEach (crew _this); \
                        _this call EFUNC(main,cleanup); \
                        _this doMove [0,0,0]; \
                        _this setVariable [QGVAR(status),TR_WAITING,false]; \
    				}; \
    			}, \
    			_this select 0, \
    			TR_IDLE_TIME \
    		] call CBA_fnc_waitAndExecute; \
        } \
    ] call EFUNC(main,landAt)
#define TR_INFIL(TRANSPORT) \
    [ \
        {_this getVariable [VAR_SIGNAL,-1] isEqualTo 1}, \
        { \
            _this removeAllEventHandlers "GetIn"; \
            [ \
                _this, \
                _this getVariable VAR_HELIPAD_INFIL, \
                "GET OUT", \
                { \
                    [ \
                        { \
                            {if !(_x isEqualTo (driver _this)) then {moveOut _x}} forEach (crew _this); \
                            _this call EFUNC(main,cleanup); \
                            _this doMove [0,0,0]; \
                            _this setVariable [QGVAR(status),TR_WAITING,false]; \
                            _this animateDoor ["door_R", 0]; \
                            _this animateDoor ["door_L", 0]; \
                            _this animateDoor ["CargoRamp_Open", 0]; \
                            _this animateDoor ["Door_rear_source", 0]; \
                            _this animateDoor ["Door_6_source", 0]; \
                            _this animate ["dvere1_posunZ", 0]; \
                            _this animate ["dvere2_posunZ", 0]; \
                        }, \
                        _this select 0, \
                        10 \
                    ] call CBA_fnc_waitAndExecute; \
                }] call EFUNC(main,landAt); \
        }, \
        TRANSPORT \
    ] call CBA_fnc_waitUntilAndExecute

#define REQUEST_ID QUOTE(DOUBLES(ADDON,request))
#define REQUEST_NAME "Request Transport"
#define REQUEST_CHILD call FUNC(getChildren)
#define REQUEST_COND call FUNC(canCallTransport)

#define SIGNAL_ID QUOTE(DOUBLES(ADDON,signal))
#define SIGNAL_NAME "Signal Take Off"
#define SIGNAL_STATEMENT (objectParent player) setVariable [VAR_SIGNAL,1,true]
#define SIGNAL_COND !(isNull objectParent player) && {((objectParent player) getVariable [VAR_SIGNAL,-1]) isEqualTo 0}
