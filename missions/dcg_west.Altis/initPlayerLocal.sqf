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
			player createDiaryRecord ["Diary", ["External Content", "<br/>VVS by Tonic<br/>"]];
			player createDiaryRecord ["Diary", ["Mission Info", format ["<br/>Author: Nicholas Clark (SENSEI)"]]];
		};

		endLoadingScreen;
	},
	[]
] call CBA_fnc_waitUntilAndExecute;
