/*
Author: Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
#include "script_component.hpp"

if (!hasInterface || {!(CHECK_ADDON_1("dcg_main"))}) exitWith {}; // headless client exit

waitUntil {DOUBLES(PREFIX,main)}; // wait until main addon completes postInit

startLoadingScreen ["Loading Mission"];

// misc
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // BIS group management
player addRating 9999999;
player addEventHandler ["HandleRating",{
	if (rating (_this select 0) < 0) then {
		abs (rating (_this select 0));
	};
}];

// debug
if (CHECK_DEBUG) then {
	player setVariable ["ace_medical_allowDamage",false];
	player addEventHandler ["handleDamage",{false}];
};

// ACE3
if (CHECK_ADDON_1("ace_medical")) then {
	if (ace_medical_level isEqualTo 1) then { // if basic medical is used set all players as medic
		player setVariable ["ace_medical_medicClass",1];
	};
};

if (!CHECK_DEBUG && {CHECK_ADDON_1("ace_safemode")}) then {
	[{
	    if (CHECK_DIST2D(locationPosition EGVAR(main,mobLocation),getPosATL player,EGVAR(main,mobRadius))) then {
	        if !(player getVariable ["dcg_safeWeapon",false]) then {
	        	player setVariable ["dcg_safeWeapon",true];
	        	player setVariable ["ace_medical_allowDamage",false];
	            player allowDamage false;
	            if !(currentWeapon player in (player getVariable ["ace_safemode_safedweapons",[]])) then {
	            	[player, currentWeapon player, currentMuzzle player] call ace_safemode_fnc_lockSafety;
	            };
	        };
	    } else {
	        if (player getVariable ["dcg_safeWeapon",false]) then {
	        	player setVariable ["dcg_safeWeapon",false];
	        	player setVariable ["ace_medical_allowDamage",true];
	            player allowDamage true;
	            if (currentWeapon player in (player getVariable ["ace_safemode_safedweapons",[]])) then {
	            	[player, currentWeapon player, currentMuzzle player] call ace_safemode_fnc_lockSafety;
	            };
	        };
	    };
	}, 5, []] call CBA_fnc_addPerFrameHandler;
};

// vehicle hud
call compile preprocessFileLineNumbers "scripts\hud\hud_teamlist.sqf";

// disable 3rd person cam
if (GVAR(disableCam)) then {
	[{
		if (GVAR(disableCam) && {cameraOn isEqualTo player} && {cameraView isEqualTo "EXTERNAL"}) then {
			["Third person camera is disabled.",true] call EFUNC(main,displayText);
			player switchCamera "INTERNAL";
		};
	}, 1, []] call CBA_fnc_addPerFrameHandler;
};

// briefing
[] spawn {
	// _fixMenu = "<execute expression ='[] call compile preprocessFileLineNumbers ""\d\ace\addons\interact_menu\XEH_clientInit.sqf"";'>Force Load ACE Interaction Menu<execute/>"; // doesn't work

	player createDiaryRecord ["Diary", ["Special Thanks", "<br/>
			Bohemia Interactive<br/><br/>
			Tier1Ops<br/><br/>
			CAVE Gaming Community<br/><br/>
			Casual Arma Players<br/><br/>
			ACE3"]
	];
	player createDiaryRecord ["Diary", ["External Content", "<br/>
			VVS by Tonic<br/><br/>
			Vehicle HUD script by Tier1ops<br/><br/>
			Defuse the bomb by cobra4v320"]
	];
	player createDiaryRecord ["Diary", ["DCG Mission Info", format ["<br/>
		Author: Nicholas Clark (SENSEI)<br/><br/>
		Version: %1<br/><br/>
		Known Issues:<br/>
		ACE interaction menu may not initialize at mission start, ACE3 Github issue #1171<br/><br/>
		",QUOTE(VERSION)]]
	];
	closeDialog 0;
	_ret = [
		parseText (format ["<img size='3' valign='top' align='center' image='media\logo.paa'/><br/><br/><t align='center'>Please refer to the Field Manual in your ACE interaction menu for mission details.</t><br/><br/><t align='center'>Installed Version: %1</t><br/><t align='center'><a color='#FFCC66' href='https://www.dropbox.com/sh/k1ykwhw8wgvfmir/AADfOghkU3jLi0G9IWj8VGCva?dl=0'>Click Here for Download Archive</a></t>",QUOTE(VERSION)]),
		TITLE,
		"Field Manual",
		"Continue"
	] call bis_fnc_GUImessage;
	if (_ret) then {(findDisplay 46) createDisplay "RscDisplayFieldManual"};
};

uiSleep 5; // give postInit time to finish

if (CHECK_ADDON_1("acre_main")) then {
	player addEventHandler ["respawn",{
		deleteVehicle (_this select 1);
		[] spawn {
			call EFUNC(radio,setRadioACRE);
		};
		if (CHECK_ADDON_1("ace_safemode")) then {
			[(_this select 0), currentWeapon (_this select 0), currentMuzzle (_this select 0)] call ace_safemode_fnc_lockSafety;
			(_this select 0) setVariable ["dcg_safeWeapon",false];
		};
	}];
} else {
	player addEventHandler ["respawn",{
		deleteVehicle (_this select 1);
		if (CHECK_ADDON_1("ace_safemode")) then {
			[(_this select 0), currentWeapon (_this select 0), currentMuzzle (_this select 0)] call ace_safemode_fnc_lockSafety;
			(_this select 0) setVariable ["dcg_safeWeapon",false];
		};
	}];
};

if !(VERSION_RELEASE) then {
	[{
		[format ["%1 %2 IS FOR PRIVATE USE ONLY!", toUpper QUOTE(PREFIX),QUOTE(VERSION)],true] call EFUNC(main,displayText);
	}, 1200, []] call CBA_fnc_addPerFrameHandler;
};

endLoadingScreen;