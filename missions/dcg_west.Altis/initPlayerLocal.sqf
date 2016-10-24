/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
[
	{!isNil "dcg_main" && {dcg_main}},
	{
		startLoadingScreen ["Loading Mission"];

		["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

    // make sure player rating stays above 0, so friendly AI units don't turn hostile
		player addRating 9999999;
		player addEventHandler ["HandleRating",{
			if (rating (_this select 0) < 0) then {
				abs (rating (_this select 0));
			};
		}];

		// add a simple weapon's safety script to work with safezone
    // also disable player damage in safezone
    // this runs client side so it's not part of the main safezone functionality
		if (isClass (configfile >> "CfgPatches" >> "ace_safemode")) then {
			player addEventHandler ["respawn",{
				[(_this select 0), currentWeapon (_this select 0), currentMuzzle (_this select 0)] call ace_safemode_fnc_lockSafety;
				(_this select 0) setVariable ["dcg_safeWeapon",false];
			}];

			[{
			    if ((locationPosition dcg_main_baseLocation) distance2D (getPosATL player) <= dcg_main_baseRadius) then {
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

		// disable 3rd person cam if selected in mission params
		if (dcg_mission_disableCam) then {
			[{
				if (dcg_mission_disableCam && {cameraOn isEqualTo player} && {cameraView isEqualTo "EXTERNAL"}) then {
					["Third person camera is disabled.",true] call dcg_main_fnc_displayText;
					player switchCamera "INTERNAL";
				};
			}, 1, []] call CBA_fnc_addPerFrameHandler;
		};

		// briefing
		[] spawn {
			player createDiaryRecord ["Diary", ["External Content", "<br/>
					VVS by Tonic<br/>"]
			];
			player createDiaryRecord ["Diary", ["Mission Info", format ["<br/>Author: Nicholas Clark (SENSEI)"]]
			];
		};

		endLoadingScreen;
	},
	[]
] call CBA_fnc_waitUntilAndExecute;
