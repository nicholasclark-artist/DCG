/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
startLoadingScreen ["Loading Mission"];

["InitializePlayer", [player,true]] call BIS_fnc_dynamicGroups;

// make sure player rating stays above 0, so friendly AI units don't turn hostile
player addEventHandler ["HandleRating",{
    if (rating (_this select 0) < 0) then {
        abs (rating (_this select 0));
    };
}];

// briefing
[] spawn {
    _openFM = "<execute expression =""[] spawn {openMap [false, false]; (findDisplay 46) createDisplay 'RscDisplayFieldManual'}"">Open Field Manual</execute>";
    player createDiaryRecord ["Diary", ["2. External Content", "<br/>VVS by Tonic<br/>"]];
    player createDiaryRecord ["Diary", ["1. Mission Info", format ["<br/>%1<br/><br/>Author: Nicholas Clark (SENSEI)<br/><br/>This work is licensed under GNU General Public License (GPLv2).<br/><br/>",_openFM]]];
};

endLoadingScreen;
