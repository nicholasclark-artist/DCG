#include "script_component.hpp"
#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

#define FADE_DELAY	0.15

disableserialization;

_mode = [_this,0,"Open",[displaynull,""]] call bis_fnc_param;
_this = [_this,1,[]] call bis_fnc_param;
_fullVersion = missionnamespace getvariable ["BIS_fnc_arsenal_fullArsenal",false];

switch _mode do {
	case "Open": {
		if !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])) exitwith {"Arsenal Viewer is already running" call bis_fnc_logFormat;};
		missionnamespace setvariable ["BIS_fnc_arsenal_fullArsenal",[_this,0,false,[false]] call bis_fnc_param];

		with missionnamespace do {
		BIS_fnc_arsenal_cargo = [_this,1,objnull,[objnull]] call bis_fnc_param;
		BIS_fnc_arsenal_center = [_this,2,player,[player]] call bis_fnc_param;
		};
		with uinamespace do {
		_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
		if !(isnull finddisplay 312) then {_displayMission = finddisplay 312;};
		_displayMission createdisplay "RscDisplayArsenal";
		};
	};


	case "Init": {
		[QFUNC(arsenal)] call bis_fnc_startloadingscreen;
		_display = _this select 0;
		_toggleSpace = uinamespace getvariable ["BIS_fnc_arsenal_toggleSpace",false];
		BIS_fnc_arsenal_type = 0;
		BIS_fnc_arsenal_toggleSpace = nil;

		if (_fullVersion) then {
		if (vehicle player != player) then {
		moveout player;
		player switchaction "playerstand";
		[player,0] call bis_fnc_setheight;
		};
		player switchcamera cameraview;


		if (time < 1) then {
		_defaultArray = uinamespace getvariable ["bis_fnc_arsenal_defaultClass",[]];
		_defaultClass = [_defaultArray,0,"",[""]] call bis_fnc_paramin;
		if (isclass (configfile >> "cfgvehicles" >> _defaultClass)) then {


		[player,_defaultClass] call FUNC(loadInventory);

		_defaultItems = [_defaultArray,1,[],[[]]] call bis_fnc_paramin;
		_defaultShow = [_defaultArray,2,-1,[0]] call bis_fnc_paramin;
		uinamespace setvariable ["bis_fnc_arsenal_defaultItems",_defaultItems];
		uinamespace setvariable ["bis_fnc_arsenal_defaultShow",_defaultShow];
		} else {
		_soldiers = [];
		{
		_soldiers pushback (configname _x);
		} foreach ("isclass _x && getnumber (_x >> 'scope') > 1 && gettext (_x >> 'simulation') == 'soldier'" configclasses (configfile >> "cfgvehicles"));
		[player,_soldiers call bis_fnc_selectrandom] call FUNC(loadInventory);
		};
		uinamespace setvariable ["bis_fnc_arsenal_defaultClass",nil];
		};
		};

				_types = [];		_types set [		3,["Uniform"]];		_types set [			4,["Vest"]];		_types set [		5,["Backpack"]];		_types set [		6,["Headgear"]];		_types set [		7,["Glasses"]];		_types set [			8,["NVGoggles"]];		_types set [		9,["Binocular","LaserDesignator"]];		_types set [		0,["AssaultRifle","MachineGun","SniperRifle","Shotgun","Rifle","SubmachineGun"]];		_types set [	1,["Launcher","MissileLauncher","RocketLauncher"]];		_types set [		2,["Handgun"]];		_types set [			10,["Map"]];		_types set [			11,["GPS","UAVTerminal"]];		_types set [			12,[/*"Radio"*/]];		_types set [		13,["Compass"]];		_types set [			14,["Watch"]];		_types set [			15,[]];		_types set [			16,[]];		_types set [		17,[]];		_types set [		18,[]];		_types set [		19,[]];		_types set [		20,[]];		_types set [		25,[]];		_types set [		21,[]];		_types set [		22,[]];		_types set [		23,[]];		_types set [		24,["FirstAidKit","Medikit","MineDetector","Toolkit"]];
		["InitGUI",[_display,QFUNC(arsenal)]] call FUNC(arsenal);
		["Preload"] call FUNC(arsenal);
		["ListAdd",[_display]] call FUNC(arsenal);
		["ListSelectCurrent",[_display]] call FUNC(arsenal);


		if (isnil {uinamespace getvariable "bis_fnc_arsenal_weaponStats"}) then {
		uinamespace setvariable [
		"bis_fnc_arsenal_weaponStats",
		[
		("isclass _x && getnumber (_x >> 'scope') == 2 && getnumber (_x >> 'type') < 5") configclasses (configfile >> "cfgweapons"),
			["reloadtime","dispersion","maxrange","hit","mass","initSpeed"],	[true,true,true,true,false,false]
		] call bis_fnc_configExtremes
		];
		};
		if (isnil {uinamespace getvariable "bis_fnc_arsenal_equipmentStats"}) then {
		_statsEquipment = [
		("isclass _x && getnumber (_x >> 'scope') == 2 && getnumber (_x >> 'itemInfo' >> 'type') in [605,701,801]") configclasses (configfile >> "cfgweapons"),
			["armor","maximumLoad","mass"],	[true,false,false]
		] call bis_fnc_configExtremes;
		_statsBackpacks = [
		("isclass _x && getnumber (_x >> 'scope') == 2 && getnumber (_x >> 'isBackpack') == 1") configclasses (configfile >> "cfgvehicles"),
			["armor","maximumLoad","mass"],	[true,false,false]
		] call bis_fnc_configExtremes;

		_statsEquipmentMin = _statsEquipment select 0;
		_statsEquipmentMax = _statsEquipment select 1;
		_statsBackpacksMin = _statsBackpacks select 0;
		_statsBackpacksMax = _statsBackpacks select 1;
		for "_i" from 1 to 2 do {
		_statsEquipmentMin set [_i,(_statsEquipmentMin select _i) min (_statsBackpacksMin select _i)];
		_statsEquipmentMax set [_i,(_statsEquipmentMax select _i) max (_statsBackpacksMax select _i)];
		};

		uinamespace setvariable ["bis_fnc_arsenal_equipmentStats",[_statsEquipmentMin,_statsEquipmentMax]];
		};

		with missionnamespace do {
		[missionnamespace,"arsenalOpened",[_display,_toggleSpace]] call bis_fnc_callscriptedeventhandler;
		};
		[QFUNC(arsenal)] call bis_fnc_endloadingscreen;
	};


	case "InitGUI": {
		_display = _this select 0;
		_function = _this select 1;
		BIS_fnc_arsenal_display = _display;
		BIS_fnc_arsenal_mouse = [0,0];
		BIS_fnc_arsenal_buttons = [[],[]];
		BIS_fnc_arsenal_action = "";
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_center hideobject false;
		cuttext ["","plain"];
		showcommandingmenu "";

		_display displayaddeventhandler ["mousebuttondown","with uinamespace do {['MouseButtonDown',_this] call dcg_main_fnc_arsenal;};"];
		_display displayaddeventhandler ["mousebuttonup","with uinamespace do {['MouseButtonUp',_this] call dcg_main_fnc_arsenal;};"];

		_display displayaddeventhandler ["keydown","with (uinamespace) do {['KeyDown',_this] call dcg_main_fnc_arsenal;};"];

		_ctrlMouseArea = _display displayctrl 			899;
		_ctrlMouseArea ctrladdeventhandler ["mousemoving","with uinamespace do {['Mouse',_this] call dcg_main_fnc_arsenal;};"];
		_ctrlMouseArea ctrladdeventhandler ["mouseholding","with uinamespace do {['Mouse',_this] call dcg_main_fnc_arsenal;};"];
		_ctrlMouseArea ctrladdeventhandler ["mousebuttonclick","with uinamespace do {['TabDeselect',[ctrlparent (_this select 0),_this select 1]] call dcg_main_fnc_arsenal;};"];
		_ctrlMouseArea ctrladdeventhandler ["mousezchanged","with uinamespace do {['MouseZChanged',_this] call dcg_main_fnc_arsenal;};"];
		ctrlsetfocus _ctrlMouseArea;

		_ctrlMouseBlock = _display displayctrl 		898;
		_ctrlMouseBlock ctrlenable false;
		_ctrlMouseBlock ctrladdeventhandler ["setfocus",{_this spawn {disableserialization; (_this select 0) ctrlenable false; (_this select 0) ctrlenable true;};}];

		_ctrlMessage = _display displayctrl 			996;
		_ctrlMessage ctrlsetfade 1;
		_ctrlMessage ctrlcommit 0;

		_ctrlInfo = _display displayctrl 		25815;
		_ctrlInfo ctrlsetfade 1;
		_ctrlInfo ctrlcommit 0;

		_ctrlStats = _display displayctrl 		28644;
		_ctrlStats ctrlsetfade 1;
		_ctrlStats ctrlenable false;
		_ctrlStats ctrlcommit 0;


		_ctrlButtonInterface = _display displayctrl 	44151;
		_ctrlButtonInterface ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonInterface',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];

		_ctrlButtonRandom = _display displayctrl 	44150;
		_ctrlButtonRandom ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonRandom',[ctrlparent (_this select 0)]] call %1;};",_function]];

		_ctrlButtonSave = _display displayctrl 		44146;
		_ctrlButtonSave ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonSave',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];

		_ctrlButtonLoad = _display displayctrl 		44147;
		_ctrlButtonLoad ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonLoad',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];

		_ctrlButtonExport = _display displayctrl 	44148;
		_ctrlButtonExport ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonExport',[ctrlparent (_this select 0),'init']] call %1;};",_function]];
		_ctrlButtonExport ctrlenable !ismultiplayer;

		_ctrlButtonImport = _display displayctrl 	44149;
		_ctrlButtonImport ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonImport',[ctrlparent (_this select 0),'init']] call %1;};",_function]];

		_ctrlButtonOK = _display displayctrl 		44346;
		_ctrlButtonOK ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonOK',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];

		_ctrlButtonTry = _display displayctrl 		44347;
		_ctrlButtonTry ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonTry',[ctrlparent (_this select 0)]] call bis_fnc_garage;};"];

		_ctrlArrowLeft = _display displayctrl 			992;
		_ctrlArrowLeft ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonCargo',[ctrlparent (_this select 0),-1]] call dcg_main_fnc_arsenal;};"];

		_ctrlArrowRight = _display displayctrl 		993;
		_ctrlArrowRight ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonCargo',[ctrlparent (_this select 0),+1]] call dcg_main_fnc_arsenal;};"];

		_ctrlTemplateButtonOK = _display displayctrl 		36019;
		_ctrlTemplateButtonOK ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['buttonTemplateOK',[ctrlparent (_this select 0)]] call %1;};",_function]];

		_ctrlTemplateButtonCancel = _display displayctrl 	36020;
		_ctrlTemplateButtonCancel ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonTemplateCancel',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];

		_ctrlTemplateButtonDelete = _display displayctrl 	36021;
		_ctrlTemplateButtonDelete ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonTemplateDelete',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];

		_ctrlTemplateValue = _display displayctrl 		35119;
		_ctrlTemplateValue ctrladdeventhandler ["lbselchanged","with uinamespace do {['templateSelChanged',[ctrlparent (_this select 0)]] call dcg_main_fnc_arsenal;};"];
		_ctrlTemplateValue ctrladdeventhandler ["lbdblclick",format ["with uinamespace do {['buttonTemplateOK',[ctrlparent (_this select 0)]] call %1;};",_function]];


		_ctrlIcon = _display displayctrl 			930;
		_ctrlIconPos = ctrlposition _ctrlIcon;
		_ctrlTabs = _display displayctrl 			1800;
		_ctrlTabsPos = ctrlposition _ctrlTabs;
		_ctrlTabsPosX = _ctrlTabsPos select 0;
		_ctrlTabsPosY = _ctrlTabsPos select 1;
		_ctrlIconPosW = _ctrlIconPos select 2;
		_ctrlIconPosH = _ctrlIconPos select 3;
		_columns = (_ctrlTabsPos select 2) / _ctrlIconPosW;
		_rows = (_ctrlTabsPos select 3) / _ctrlIconPosH;
		_gridH = ctrlposition _ctrlTemplateButtonOK select 3;

		{
			_idc = _x;
			_ctrlIcon = _display displayctrl (			900 + _idc);
			_ctrlTab = _display displayctrl (			930 + _idc);
			_mode = if (_idc in [			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17]) then {"TabSelectLeft"} else {"TabSelectRight"};
			{
				_x ctrladdeventhandler ["buttonclick",format ["with uinamespace do {['%2',[ctrlparent (_this select 0),%1]] call %3;};",_idc,_mode,_function]];
				_x ctrladdeventhandler ["mousezchanged","with uinamespace do {['MouseZChanged',_this] call dcg_main_fnc_arsenal;};"];
			} foreach [_ctrlIcon,_ctrlTab];

			_ctrlList = _display displayctrl (			960 + _idc);
			_ctrlList ctrlenable false;
			_ctrlList ctrlsetfade 1;
			_ctrlList ctrlsetfontheight (_gridH * 0.8);
			_ctrlList ctrlcommit 0;
			_ctrlList ctrladdeventhandler ["lbselchanged",format ["with uinamespace do {['SelectItem',[ctrlparent (_this select 0),(_this select 0),%1]] call %2;};",_idc,_function]];
			_ctrlList ctrladdeventhandler ["lbdblclick",format ["with uinamespace do {['ShowItem',[ctrlparent (_this select 0),(_this select 0),%1]] spawn dcg_main_fnc_arsenal;};",_idc]];

			_ctrlListDisabled = _display displayctrl (		860 + _idc);
			_ctrlListDisabled ctrlenable false;
		} foreach 	[			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17,			18,			19,			20,			25,			21,			22,			23,			24];
		['TabDeselect',[_display,-1]] call FUNC(arsenal);
		['SelectItem',[_display,controlnull,-1]] call (uinamespace getvariable _function);

		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlenable false;
			_ctrl ctrlsetfade 1;
			_ctrl ctrlcommit 0;
		} foreach [
					1801,
				1802,
				994,
				995,
					1803,
				1804,
				1806,
				35919
		];

		_ctrlButtonClose = _display displayctrl 	44448;
		_ctrlButtonClose ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonClose',[ctrlparent (_this select 0)]] spawn dcg_main_fnc_arsenal;}; true"];

		if (missionname == "Arsenal") then {
			_ctrlButtonClose ctrlsettext localize "STR_DISP_ARCMAP_EXIT";
		};
		if (missionname != "arsenal") then {
			_ctrlButtonOK ctrlsettext "";
			_ctrlButtonOK ctrlenable false;
			_ctrlButtonOK ctrlsettooltip "";
			_ctrlButtonTry ctrlsettext "";
			_ctrlButtonTry ctrlenable false;
			_ctrlButtonTry ctrlsettooltip "";
		};

		if (_fullVersion) then {
			if (missionname == "Arsenal") then {
			_ctrlSpace = _display displayctrl 			27903;
			_ctrlSpace ctrlshow true;
			{
			_ctrl = _display displayctrl (_x select 0);
			_ctrlBackground = _display displayctrl (_x select 1);
			_ctrl ctrladdeventhandler ["buttonclick","with uinamespace do {['buttonSpace',_this] spawn dcg_main_fnc_arsenal;}; true"];
			if (_foreachindex == bis_fnc_arsenal_type) then {
			_ctrl ctrlenable false;
			_ctrl ctrlsettextcolor [1,1,1,1];
			_ctrlBackground ctrlsetbackgroundcolor [0,0,0,1];
			};
			} foreach [
			[		26803,	26603],
			[		26804,	26604]
			];
			} else {
			_ctrlSpace = _display displayctrl 			27903;
			_ctrlSpace ctrlsetposition [-1,-1,0,0];
			_ctrlSpace ctrlcommit 0;
			};
		} else {
			{
			_tab = _x;
			{
			_ctrl = _display displayctrl (_tab + _x);
			_ctrl ctrlshow false;
			_ctrl ctrlenable false;
			_ctrl ctrlremovealleventhandlers "buttonclick";
			_ctrl ctrlremovealleventhandlers "mousezchanged";
			_ctrl ctrlremovealleventhandlers "lbselchanged";
			_ctrl ctrlremovealleventhandlers "lbdblclick";
			_ctrl ctrlsetposition [0,0,0,0];
			_ctrl ctrlcommit 0;
			} foreach [			930,			900];
			} foreach [
						15,
						16,
					17
			];
		};

		BIS_fnc_arsenal_campos = uinamespace getvariable [
			format ["BIS_fnc_arsenal_campos_%1",BIS_fnc_arsenal_type],
			if (BIS_fnc_arsenal_type == 0) then {[5,0,0,[0,0,0.85]]} else {[10,-45,15,[0,0,-1]]}
		];
		BIS_fnc_arsenal_campos = +BIS_fnc_arsenal_campos;
		_target = createagent ["Logic",position _center,[],0,"none"];
		_target attachto [_center,BIS_fnc_arsenal_campos select 3,""];
		missionnamespace setvariable ["BIS_fnc_arsenal_target",_target];

		_cam = "camera" camcreate position _center;
		_cam cameraeffect ["internal","back"];
		_cam campreparefocus [-1,-1];
		_cam campreparefov 0.35;
		_cam camcommitprepared 0;
		cameraEffectEnableHUD true;
		showcinemaborder false;
		BIS_fnc_arsenal_cam = _cam;
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;

		BIS_fnc_arsenal_draw3D = addMissionEventHandler ["draw3D",{with (uinamespace) do {['draw3D',_this] call FUNC(arsenal);};}];

		setacctime (missionnamespace getvariable ["BIS_fnc_arsenal_acctime",1]);
	};

	case "Preload": {
		private ["_data"];
		_data = missionnamespace getvariable "bis_fnc_arsenal_data";
		if (isnil "_data") then {
		["bis_fnc_arsenal_preload"] call bis_fnc_startloadingscreen;
				_types = [];		_types set [		3,["Uniform"]];		_types set [			4,["Vest"]];		_types set [		5,["Backpack"]];		_types set [		6,["Headgear"]];		_types set [		7,["Glasses"]];		_types set [			8,["NVGoggles"]];		_types set [		9,["Binocular","LaserDesignator"]];		_types set [		0,["AssaultRifle","MachineGun","SniperRifle","Shotgun","Rifle","SubmachineGun"]];		_types set [	1,["Launcher","MissileLauncher","RocketLauncher"]];		_types set [		2,["Handgun"]];		_types set [			10,["Map"]];		_types set [			11,["GPS","UAVTerminal"]];		_types set [			12,[/*"Radio"*/]];		_types set [		13,["Compass"]];		_types set [			14,["Watch"]];		_types set [			15,[]];		_types set [			16,[]];		_types set [		17,[]];		_types set [		18,[]];		_types set [		19,[]];		_types set [		20,[]];		_types set [		25,[]];		_types set [		21,[]];		_types set [		22,[]];		_types set [		23,[]];		_types set [		24,["FirstAidKit","Medikit","MineDetector","Toolkit"]];
		_data = [];
		{
		_data set [_x,[]];
		} foreach 	[			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17,			18,			19,			20,			25,			21,			22,			23,			24];

		_configArray = (
		("isclass _x" configclasses (configfile >> "cfgweapons")) +
		("isclass _x" configclasses (configfile >> "cfgvehicles")) +
		("isclass _x" configclasses (configfile >> "cfgglasses"))
		);
		_progressStep = 1 / count _configArray;
		{
		_class = _x;
		_className = configname _x;
		_scope = if (isnumber (_class >> "scopeArsenal")) then {getnumber (_class >> "scopeArsenal")} else {getnumber (_class >> "scope")};
		_isBase = if (isarray (_x >> "muzzles")) then {(_className call bis_fnc_baseWeapon == _className)} else {true};
		if (_scope == 2 && {gettext (_class >> "model") != ""} && _isBase) then {
		private ["_weaponType","_weaponTypeCategory"];
		_weaponType = (_className call bis_fnc_itemType);
		_weaponTypeCategory = _weaponType select 0;
		if (_weaponTypeCategory != "VehicleWeapon") then {
		private ["_weaponTypeSpecific","_weaponTypeID"];
		_weaponTypeSpecific = _weaponType select 1;
		_weaponTypeID = -1;
		{
		if (_weaponTypeSpecific in _x) exitwith {_weaponTypeID = _foreachindex;};
		} foreach _types;
		if (_weaponTypeID >= 0) then {
		private ["_items"];
		_items = _data select _weaponTypeID;
		_items set [count _items,configname _class];
		};
		};
		};
		progressloadingscreen (_foreachindex * _progressStep);
		} foreach _configArray;


		if (_fullVersion) then {
		{
		private ["_index"];
		_index = _foreachindex;
		{
		if (getnumber (_x >> "disabled") == 0 && gettext (_x >> "head") != "" && configname _x != "Default") then {
		private ["_items"];
		_items = _data select 			15;
		_items set [count _items,[_x,_index]];
		};
		} foreach ("isclass _x" configclasses _x);
		} foreach ("isclass _x" configclasses (configfile >> "cfgfaces"));


		{
		_scope = if (isnumber (_x >> "scopeArsenal")) then {getnumber (_x >> "scopeArsenal")} else {getnumber (_x >> "scope")};
		if (_scope == 2 && gettext (_x >> "protocol") != "RadioProtocolBase") then {
		private ["_items"];
		_items = _data select 			16;
		_items set [count _items,configname _x];
		};
		} foreach ("isclass _x" configclasses (configfile >> "cfgvoice"));


		{
		private ["_items"];
		_scope = if (isnumber (_x >> "scope")) then {getnumber (_x >> "scope")} else {2};
		if (_scope == 2) then {
		_items = _data select 		17;
		_items set [count _items,configname _x];
		};
		} foreach ("isclass _x" configclasses (configfile >> "cfgunitinsignia"));
		};


		{
		private ["_weapons","_tab","_magazines"];
		_weapon = _x select 0;
		_tab = _x select 1;
		_magazines = [];
		{
		{
		private ["_mag"];
		_mag = _x;
		if ({_x == _mag} count _magazines == 0) then {
		private ["_cfgMag"];
		_magazines set [count _magazines,_mag];
		_cfgMag = configfile >> "cfgmagazines" >> _mag;
		if (getnumber (_cfgMag >> "scope") == 2 || getnumber (_cfgMag >> "scopeArsenal") == 2) then {
		private ["_items"];
		_items = _data select _tab;
		_items set [count _items,configname _cfgMag];
		};
		};
		} foreach getarray (_x >> "magazines");
		} foreach ("isclass _x" configclasses (configfile >> "cfgweapons" >> _weapon));
		} foreach [
		["throw",		22],
		["put",		23]
		];

		missionnamespace setvariable ["bis_fnc_arsenal_data",_data];
		["bis_fnc_arsenal_preload"] call bis_fnc_endloadingscreen;
		true
		} else {
		false
		};
	};

	case "Exit": {
		removemissioneventhandler ["draw3D",BIS_fnc_arsenal_draw3D];

		_target = (missionnamespace getvariable ["BIS_fnc_arsenal_target",player]);
		_cam = uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull];
		_camData = [getposatl _cam,(getposatl _cam) vectorfromto (getposatl _target)];
		_cam cameraeffect ["terminate","back"];
		camdestroy _cam;

		uinamespace setvariable [format ["BIS_fnc_arsenal_campos_%1",BIS_fnc_arsenal_type],+BIS_fnc_arsenal_campos];

		BIS_fnc_arsenal_cam = nil;
		BIS_fnc_arsenal_display = nil;
		BIS_fnc_arsenal_type = nil;
		BIS_fnc_arsenal_mouse = nil;
		BIS_fnc_arsenal_buttons = nil;
		BIS_fnc_arsenal_action = nil;
		BIS_fnc_arsenal_campos = nil;

		deletevehicle (missionnamespace getvariable ["BIS_fnc_arsenal_target",objnull]);

		with missionnamespace do {
		BIS_fnc_arsenal_acctime = acctime;
		BIS_fnc_arsenal_target = nil;
		BIS_fnc_arsenal_center = nil;
		BIS_fnc_arsenal_cargo = nil;
		};

		setacctime 1;

		if !(isnull curatorcamera) then {
		curatorcamera setposatl (_camData select 0);
		curatorcamera setvectordir (_camData select 1);
		curatorcamera cameraeffect ["internal","back"];
		};
		with missionnamespace do {
		[missionnamespace,"arsenalClosed",[displaynull,uinamespace getvariable ["BIS_fnc_arsenal_toggleSpace",false]]] call bis_fnc_callscriptedeventhandler;
		};
	};


	case "draw3D": {
		_display = BIS_fnc_arsenal_display;

		_cam = (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull]);
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_target = (missionnamespace getvariable ["BIS_fnc_arsenal_target",player]);

		_dis = BIS_fnc_arsenal_campos select 0;
		_dirH = BIS_fnc_arsenal_campos select 1;
		_dirV = BIS_fnc_arsenal_campos select 2;

		[_target,[_dirH + 180,-_dirV,0]] call bis_fnc_setobjectrotation;
		_target attachto [_center,BIS_fnc_arsenal_campos select 3,""];
		_cam attachto [_target,[0,-_dis,0],""];


		if ((getposatl _cam select 2) < 0) then {
		_disCoef = (getposatl _target select 2) / ((getposatl _target select 2) - (getposatl _cam select 2) + 0.001);
		_cam attachto [_target,[0,-_dis * _disCoef,0],""];
		};

		if (BIS_fnc_arsenal_type == 0) then {
		_selections = [];
		_selections set [		3,		["Pelvis",						[+0.00, +0.00, -0.00]]];
		_selections set [			4,		["Spine3",						[+0.00, +0.00, +0.00]]];
		_selections set [		5,		["Spine3",						[+0.00, -0.20, +0.00]]];
		_selections set [		6,		["Head_axis",						[+0.00, +0.00, +0.00]]];
		_selections set [		7,		["Pilot",						[-0.04, +0.05, +0.00]]];
		_selections set [			8,		["Pilot",						[+0.00, -0.05, +0.05]]];
		_selections set [		9,		["Pilot",						[+0.04, +0.05, +0.00]]];
		_selections set [		0,	["proxy:\A3\Characters_F\Proxies\weapon.001",		[+0.00, +0.00, +0.00]]];
		_selections set [	1,	["proxy:\A3\Characters_F\Proxies\launcher.001",		[+0.00, +0.00, +0.00]]];
		_selections set [		2,		["proxy:\A3\Characters_F\Proxies\pistol.001",		[+0.00, +0.00, +0.00]]];
		_selections set [			10,			["",[0, 0,0]]];
		_selections set [			11,			["",[0, 0,0]]];
		_selections set [			12,		["",[0, 0,0]]];
		_selections set [		13,		["",[0, 0,0]]];
		_selections set [			14,		["",[0, 0,0]]];
		_selections set [			15,		["Head_axis",						[+0.05, +0.10, -0.05]]];
		_selections set [			16,		["",[0, 0,0]]];
		_selections set [		17,		["LeftShoulder",					[+0.00, +0.00, +0.00]]];






		_fade = 1;
		{
		_selPos = _center selectionposition (_x select 0);
		if (_selPos distance [0,0,0] > 0) then {
		_selPos = [_selPos,_x select 1] call bis_fnc_vectorAdd;
		_pos = _center modeltoworld _selPos;
		_uiPos = worldtoscreen _pos;
		if (count _uiPos > 0) then {
		_fade = _fade min (_uiPos distance BIS_fnc_arsenal_mouse);
		_index = _foreachindex;
		_ctrlPos = [];
		{
		_ctrl = _display displayctrl (_x + _index);
		_ctrlPos = ctrlposition _ctrl;
		_ctrlPos set [0,(_uiPos select 0) - (_ctrlPos select 2) * 0.5];
		_ctrlPos set [1,(_uiPos select 1) - (_ctrlPos select 3) * 0.5];
		_ctrl ctrlsetposition _ctrlPos;
		_ctrl ctrlcommit 0;
		} foreach [			900,		830];

		_ctrlList = _display displayctrl (			960 + _foreachindex);
		_ctrlLineIcon = _display displayctrl 			1803;
		if (ctrlfade _ctrlList == 0) then {
		_ctrlLinePosX = (_uiPos select 0) - (_ctrlPos select 2) * 0.5;
		_ctrlLineIcon ctrlsetposition [
		(_uiPos select 0) - (_ctrlPos select 2) * 0.5,
		_uiPos select 1,
		(ctrlposition _ctrlList select 0) + (ctrlposition _ctrlList select 2) - _ctrlLinePosX,
		0
		];
		_ctrlLineIcon ctrlsetfade 0;
		_ctrlLineIcon ctrlcommit 0;
		} else {
		if (ctrlfade _ctrlLineIcon == 0) then {
		_ctrlLineIcon ctrlsetfade 0.01;
		_ctrlLineIcon ctrlcommit 0;
		_ctrlLineIcon ctrlsetfade 1;
		_ctrlLineIcon ctrlcommit 	0.15;
		};
		};
		};
		};
		} foreach _selections;

		_fade = ((_fade - safezoneW * 0.1) * safezoneW) max 0;
		{
		_index = _foreachindex;
		_ctrl = _display displayctrl (			900 + _index);
		_ctrlFade = if !(ctrlenabled _ctrl) then {0} else {_fade};
		{
		_ctrl = _display displayctrl (_x + _index);
		_ctrl ctrlsetfade _ctrlFade;
		_ctrl ctrlcommit 0;
		} foreach [			900,		830];
		} foreach _selections;
		};
	};


	case "Mouse": {
		_ctrl = _this select 0;
		_mX = _this select 1;
		_mY = _this select 2;
		BIS_fnc_arsenal_mouse = [_mX,_mY];

		_cam = (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull]);
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_target = (missionnamespace getvariable ["BIS_fnc_arsenal_target",player]);

		_dis = BIS_fnc_arsenal_campos select 0;
		_dirH = BIS_fnc_arsenal_campos select 1;
		_dirV = BIS_fnc_arsenal_campos select 2;
		_targetPos = BIS_fnc_arsenal_campos select 3;
		_disLocal = _dis;

		_LMB = BIS_fnc_arsenal_buttons select 0;
		_RMB = BIS_fnc_arsenal_buttons select 1;

		if (isnull _ctrl) then {_LMB = [0,0];};

		if (count _LMB > 0) then {
		_cX = _LMB select 0;
		_cY = _LMB select 1;
		_dX = (_cX - _mX);
		_dY = (_cY - _mY);
		BIS_fnc_arsenal_buttons set [0,[_mX,_mY]];

		_centerBox = boundingboxreal _center;
		_centerSizeBottom = _centerBox select 0 select 2;
		_centerSizeUp = _centerBox select 1 select 2;
		_centerSize = sqrt ([_centerBox select 0 select 0,_centerBox select 0 select 1] distance [_centerBox select 1 select 0,_centerBox select 1 select 1]);
		_targetPos = [_targetPos,_dX * _centerSize,_dirH - 90] call bis_fnc_relpos;
		_targetPos = [
		[0,0,((_targetPos select 2) - _dY * _centerSize) max _centerSizeBottom min _centerSizeUp],
		([[0,0,0],_targetPos] call bis_fnc_distance2D) min _centerSize,
		[[0,0,0],_targetPos] call bis_fnc_dirto
		] call bis_fnc_relpos;


		_posZmin = 0.1;
		_targetWorldPosZ = (_center modeltoworld _targetPos) select 2;
		if (_targetWorldPosZ < _posZmin) then {_targetPos set [2,(_targetPos select 2) - _targetWorldPosZ + _posZmin];};
		BIS_fnc_arsenal_campos set [3,_targetPos];
		};

		if (count _RMB > 0) then {
		_cX = _RMB select 0;
		_cY = _RMB select 1;
		_dX = (_cX - _mX) * 0.75;
		_dY = (_cY - _mY) * 0.75;
		_targetPos = [
		[0,0,_targetPos select 2],
		[[0,0,0],_targetPos] call bis_fnc_distance2D,
		([[0,0,0],_targetPos] call bis_fnc_dirto) - _dX * 180
		] call bis_fnc_relpos;

		BIS_fnc_arsenal_campos set [1,(_dirH - _dX * 180) % 360];
		BIS_fnc_arsenal_campos set [2,(_dirV - _dY * 100) max -89 min 89];
		BIS_fnc_arsenal_campos set [3,_targetPos];
		BIS_fnc_arsenal_buttons set [1,[_mX,_mY]];
		};

		if (isnull _ctrl) then {BIS_fnc_arsenal_buttons = [[],[]];};


		if (!alive _center || isnull _center) then {
		(ctrlparent (_this select 0)) closedisplay 2;
		};
	};


	case "MouseButtonDown": {
		BIS_fnc_arsenal_buttons set [_this select 1,[_this select 2,_this select 3]];
	};


	case "MouseButtonUp": {
		BIS_fnc_arsenal_buttons set [_this select 1,[]];
	};


	case "MouseZChanged": {
		_cam = (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull]);
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_target = (missionnamespace getvariable ["BIS_fnc_arsenal_target",player]);

		_disMax = if (bis_fnc_arsenal_type > 0) then {((boundingboxreal _center select 0) vectordistance (boundingboxreal _center select 1)) * 1.5} else {5};

		_disMin = _disMax * 0.15;
		_z = _this select 1;
		_dis = BIS_fnc_arsenal_campos select 0;
		_dis = _dis - (_z / 10);
		_dis = _dis max _disMin min _disMax;
		BIS_fnc_arsenal_campos set [0,_dis];
	};


	case "ListAdd": {
		_display = _this select 0;
		_data = missionnamespace getvariable "bis_fnc_arsenal_data";
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
		_lbAdd = -1;
		_xCfg = configfile;
		_fnc_addModIcon = {
			if (_fullVersion) then {
				_ctrlList lbsetpictureright [_lbAdd,gettext ((configfile >> "cfgMods" >> gettext (_this >> "dlc")) >> "logo")];
			};
		};

		_virtualItemCargo =		(missionnamespace call bis_fnc_getVirtualItemCargo) +		(_cargo call bis_fnc_getVirtualItemCargo) +		items _center +		assigneditems _center +		primaryweaponitems _center +		secondaryweaponitems _center +		handgunitems _center +		[uniform _center,vest _center,headgear _center,goggles _center];	_virtualWeaponCargo = [];	{		_weapon = _x call bis_fnc_baseWeapon;		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];		{			private ["_item"];			_item = gettext (_x >> "item");			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

		{
		_ctrlList = _display displayctrl (			960 + _foreachindex);
		switch _foreachindex do {
			case 		0;
			case 		1;
			case 		2: {
				_virtualCargo = _virtualWeaponCargo;
				_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
				{
					if (_virtualAll || {_x in _virtualCargo}) then {
						_xCfg = configfile >> "cfgweapons" >> _x;
						_displayName = gettext (_xCfg >> "displayName");
						_lbAdd = _ctrlList lbadd _displayName;
						_ctrlList lbsetdata [_lbAdd,_x];
						_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "picture")];
						_ctrlList lbsettooltip [_lbAdd,_displayName];
						_xCfg call _fnc_addModIcon;
					};
				} foreach _x;
			};
			case 			3;
			case 			4;
			case 			6;
			case 			8;
			case 			10;
			case 			11;
			case 			12;
			case 			13;
			case 			14: {
				_virtualCargo = _virtualItemCargo;
				_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
				{
					if (_virtualAll || {_x in _virtualCargo}) then {
					_xCfg = configfile >> "cfgweapons" >> _x;
					_displayName = gettext (_xCfg >> "displayName");
					_lbAdd = _ctrlList lbadd _displayName;;
					_ctrlList lbsetdata [_lbAdd,_x];
					_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "picture")];
					_ctrlList lbsettooltip [_lbAdd,_displayName];
					_xCfg call _fnc_addModIcon;
					};
				} foreach _x;
			};
			case 		9: {
			_virtualCargo = _virtualWeaponCargo + _virtualItemCargo;
			_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
			{
			if (_virtualAll || {_x in _virtualCargo}) then {
			_xCfg = configfile >> "cfgweapons" >> _x;
			_displayName = gettext (_xCfg >> "displayName");
			_lbAdd = _ctrlList lbadd _displayName;
			_ctrlList lbsetdata [_lbAdd,_x];
			_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "picture")];
			_ctrlList lbsettooltip [_lbAdd,_displayName];
			_xCfg call _fnc_addModIcon;
			};
			} foreach _x;

			};
			case 		7: {
			_virtualCargo = _virtualItemCargo;
			_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
			{
			if (_virtualAll || {_x in _virtualCargo}) then {
			_xCfg = configfile >> "cfgglasses" >> _x;
			_displayName = gettext (_xCfg >> "displayName");
			_lbAdd = _ctrlList lbadd _displayName;
			_ctrlList lbsetdata [_lbAdd,_x];
			_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "picture")];
			_ctrlList lbsettooltip [_lbAdd,_displayName];
			_xCfg call _fnc_addModIcon;
			};
			} foreach _x;
			};
			case 		5: {
			_virtualCargo = _virtualBackpackCargo;
			_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
			{
			if (_virtualAll || {_x in _virtualCargo}) then {
			_xCfg = configfile >> "cfgvehicles" >> _x;
			_displayName = gettext (_xCfg >> "displayName");
			_lbAdd = _ctrlList lbadd _displayName;
			_ctrlList lbsetdata [_lbAdd,_x];
			_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "picture")];
			_ctrlList lbsettooltip [_lbAdd,_displayName];
			_xCfg call _fnc_addModIcon;
			};
			} foreach _x;
			};
			case 			15: {
			{
			_displayName = gettext ((_x select 0) >> "displayName");
			_lbAdd = _ctrlList lbadd _displayName;
			_ctrlList lbsetdata [_lbAdd,configname (_x select 0)];
			_ctrlList lbsetvalue [_lbAdd,_x select 1];
			_ctrlList lbsettooltip [_lbAdd,_displayName];
			(_x select 0) call _fnc_addModIcon;
			} foreach _x;
			};
			case 			16: {
			{
			_xCfg = configfile >> "cfgvoice" >> _x;
			_displayName = ([configfile >> "cfgvoice" >> _x] call bis_fnc_displayName);
			_lbAdd = _ctrlList lbadd _displayName;
			_ctrlList lbsetdata [_lbAdd,_x];
			_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "icon")];
			_ctrlList lbsettooltip [_lbAdd,_displayName];
			_xCfg call _fnc_addModIcon;
			} foreach _x;
			};
			case 		17: {
			{
			_xCfg = configfile >> "cfgunitinsignia" >> _x;
			_displayName = gettext (_xCfg >> "displayName");
			_lbAdd = _ctrlList lbadd _displayName;
			_ctrlList lbsetdata [_lbAdd,_x];
			_ctrlList lbsetpicture [_lbAdd,gettext (_xCfg >> "texture")];
			_ctrlList lbsettooltip [_lbAdd,_displayName];
			_xCfg call _fnc_addModIcon;
			} foreach _x;
			};
			case 		22;
			case 		23: {
			_virtualCargo = _virtualMagazineCargo;
			_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
			{
			if (_virtualAll || {_x in _virtualCargo}) then {
			_xCfg = configfile >> "cfgmagazines" >> _x;
			_lbAdd = _ctrlList lnbaddrow ["",gettext (_xCfg >> "displayName"),str 0];
			_ctrlList lnbsetdata [[_lbAdd,0],_x];
			_ctrlList lnbsetpicture [[_lbAdd,0],gettext (_xCfg >> "picture")];
			_ctrlList lnbsetvalue [[_lbAdd,0],getnumber (_xCfg >> "mass")];
			};
			} foreach _x;
			};
			case 		24: {
			_virtualCargo = _virtualItemCargo;
			_virtualAll = _fullVersion || {"%ALL" in _virtualCargo};
			{
			if (_virtualAll || {_x in _virtualCargo}) then {
			_xCfg = configfile >> "cfgweapons" >> _x;
			_lbAdd = _ctrlList lnbaddrow ["",gettext (_xCfg >> "displayName"),str 0];
			_ctrlList lnbsetdata [[_lbAdd,0],_x];
			_ctrlList lnbsetpicture [[_lbAdd,0],gettext (_xCfg >> "picture")];
			_ctrlList lnbsetvalue [[_lbAdd,0],getnumber (_xCfg >> "itemInfo" >> "mass")];
			};
			} foreach _x;
			};
		};


		if !(
		_foreachindex in [
					15,
					16,
				22,
				23,
				24
		]
		) then {
		_lbAdd = _ctrlList lbadd format [" <%1>",localize "str_empty"];
		lbsort _ctrlList;
		};
		} foreach _data;
	};


	case "ListSelectCurrent": {
		_display = [_this,0,uinamespace getvariable ["bis_fnc_arsenal_display",displaynull],[displaynull]] call bis_fnc_paramin;
		_data = missionnamespace getvariable "bis_fnc_arsenal_data";
		_defaultItems = uinamespace getvariable ["bis_fnc_arsenal_defaultItems",[]];
		_defaultShow = uinamespace getvariable ["bis_fnc_arsenal_defaultShow",-1];
		{
		_ctrlList = _display displayctrl (			960 + _foreachindex);


		if (ctrltype _ctrlList == 5) then {lbsort _ctrlList;};


		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_select = true;


		_defaultItem = [_defaultItems,_foreachindex,[],["",[]]] call bis_fnc_paramin;
		if (typename _defaultItem != typename []) then {_defaultItem = [_defaultItem];};
		_current = if (count _defaultItem == 0) then {
		switch _foreachindex do {
		case 		3:		{uniform _center};
		case 			4:		{vest _center};
		case 		5:	{backpack _center};
		case 		6:	{headgear _center};
		case 		7:		{goggles _center};
		case 			8;
		case 		9:	{assigneditems _center};
		case 		0:	{[(primaryweapon _center) call bis_fnc_baseWeapon,0,""] call bis_fnc_paramin};
		case 	1:	{[(secondaryweapon _center) call bis_fnc_baseWeapon,0,""] call bis_fnc_paramin};
		case 		2:		{[(handgunweapon _center) call bis_fnc_baseWeapon,0,""] call bis_fnc_paramin};
		case 			10;
		case 			11;
		case 			12;
		case 		13;
		case 			14:		{assigneditems _center};
		case 			15:		{_center getvariable ["BIS_fnc_arsenal_face",face _center]};
		case 			16:		{speaker _center};
		case 		17:	{_center call bis_fnc_getUnitInsignia};
		default {_select = false; ""};
		};
		} else {
		if (_defaultShow < 0) then {["ShowItem",[_display,_ctrlList,_foreachindex]] spawn FUNC(arsenal);};
		[_defaultItem select 0,0,"",[""]] call bis_fnc_paramin
		};
		if (_select) then {
		if (typename _current != typename []) then {_current = [_current];};
		for "_l" from 0 to (lbsize _ctrlList - 1) do {
		if ({(_ctrlList lbdata _l) == _x} count _current > 0) exitwith {_ctrlList lbsetcursel _l;};
		};
		if (lbcursel _ctrlList < 0) then {_ctrlList lbsetcursel 0;};
		};


		if (count _defaultItem > 0) then {
		switch _foreachindex do {
		case 		0:{
		{if (_foreachindex > 0) then {_center addprimaryweaponitem _x;};} foreach _defaultItem;
		};
		case 	1:{
		{if (_foreachindex > 0) then {_center addsecondaryweaponitem _x;};} foreach _defaultItem;
		};
		case 		2:{
		{if (_foreachindex > 0) then {_center addhandgunitem _x;};} foreach _defaultItem;
		};
		};
		};
		} foreach _data;
		if (_defaultShow >= 0) then {["ShowItem",[_display,_display displayctrl (			960 + _defaultShow),_defaultShow]] spawn FUNC(arsenal);};
		uinamespace setvariable ["bis_fnc_arsenal_defaultItems",nil];
		uinamespace setvariable ["bis_fnc_arsenal_defaultShow",nil];
	};

	case "TabDeselect": {
		_display = _this select 0;
		_key = _this select 1;

		if ({count _x > 0} count BIS_fnc_arsenal_buttons == 0) then {
			_shown = ctrlshown (_display displayctrl 		44046);
			if (!_shown || _key == 1) exitwith {['buttonInterface',[_display]] call FUNC(arsenal);};

			{
			_idc = _x;
			{
			_ctrlList = _display displayctrl (_x + _idc);
			_ctrlLIst ctrlenable false;
			_ctrlList ctrlsetfade 1;
			_ctrlList ctrlcommit 	0.15;
			} foreach [			960,		860];

			_ctrlIcon = _display displayctrl (			900 + _idc);
			_ctrlTab = _display displayctrl (			930 + _idc);
			{
			_x ctrlenable true;
			_x ctrlsetfade 0;
			} foreach [_ctrlTab];
			_ctrlIcon ctrlenable true;
			_ctrlIcon ctrlshow true;

			_ctrlIconBackground = _display displayctrl (		830 + _idc);
			_ctrlIconBackground ctrlshow true;

			if (_idc in [			18,			19,			20,			25,			21,			22,			23,			24]) then {
			_ctrlList = _display displayctrl (			960 + _idc);
			{
			_x ctrlenable false;
			_x ctrlsetfade 1;
			_x ctrlcommit 	0.15;
			} foreach [_ctrlList,_ctrlTab];
			};
			} foreach 	[			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17,			18,			19,			20,			25,			21,			22,			23,			24];
			{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlsetfade 1;
			_ctrl ctrlcommit 0;
			} foreach [
						1801,
					1802,
					994,
					995,
						1803,
					1804,
					1806,
						991,
					25815,
					28644
			];
		};
	};

	case "TabSelectLeft": {
		_display = _this select 0;
		_index = _this select 1;

		{
		_ctrlList = _display displayctrl (			960 + _x);
		_ctrlList lbsetcursel -1;
		lbclear _ctrlList;
		} foreach [
				18,
				19,
				20,
				25,
				21
		];

		{
		_idc = _x;
		_active = _idc == _index;

		{
		_ctrlList = _display displayctrl (_x + _idc);
		_ctrlList ctrlenable _active;
		_ctrlList ctrlsetfade ([1,0] select _active);
		_ctrlList ctrlcommit 	0.15;
		} foreach [			960,		860];

		_ctrlTab = _display displayctrl (			930 + _idc);
		_ctrlTab ctrlenable !_active;

		if (_active) then {
		_ctrlList = _display displayctrl (			960 + _idc);
		_ctrlLineTabLeft = _display displayctrl 		1804;
		_ctrlLineTabLeft ctrlsetfade 0;
		_ctrlTabPos = ctrlposition _ctrlTab;
		_ctrlLineTabPosX = (_ctrlTabPos select 0) + (_ctrlTabPos select 2) - 0.01;
		_ctrlLineTabPosY = (_ctrlTabPos select 1);
		_ctrlLineTabLeft ctrlsetposition [
		safezoneX,
		_ctrlLineTabPosY,
		(ctrlposition _ctrlList select 0) - safezoneX,
		ctrlposition _ctrlTab select 3
		];
		_ctrlLineTabLeft ctrlcommit 0;
		ctrlsetfocus _ctrlList;
		['SelectItem',[_display,_display displayctrl (			960 + _idc),_idc]] call FUNC(arsenal);
		};

		_ctrlIcon = _display displayctrl (			900 + _idc);

		_ctrlIcon ctrlshow _active;
		_ctrlIcon ctrlenable !_active;

		_ctrlIconBackground = _display displayctrl (		830 + _idc);
		_ctrlIconBackground ctrlshow _active;
		} foreach [			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17];

		{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlsetfade 0;
		_ctrl ctrlcommit 	0.15;
		} foreach [
				1804,
					1801,
				994
		];


		_showItems = _index in [		0,	1,		2];
		_fadeItems = [1,0] select _showItems;
		{
		_idc = _x;
		_ctrl = _display displayctrl (			930 + _idc);
		_ctrl ctrlenable _showItems;
		_ctrl ctrlsetfade _fadeItems;
		_ctrl ctrlcommit 0;
		{
		_ctrlList = _display displayctrl (_x + _idc);
		_ctrlList ctrlenable _showItems;
		_ctrlList ctrlsetfade _fadeItems;
		_ctrlList ctrlcommit 	0.15;
		} foreach [			960,		860];
		} foreach [
				18,
				19,
				20,
				25
		];
		if (_showItems) then {['TabSelectRight',[_display,		18]] call FUNC(arsenal);};


		_showCargo = _index in [		3,			4,		5];
		_fadeCargo = [1,0] select _showCargo;
		{
		_idc = _x;
		_ctrl = _display displayctrl (			930 + _idc);
		_ctrl ctrlenable _showCargo;
		_ctrl ctrlsetfade _fadeCargo;
		_ctrl ctrlcommit 0;
		{
		_ctrlList = _display displayctrl (_x + _idc);
		_ctrlList ctrlenable _showCargo;
		_ctrlList ctrlsetfade _fadeCargo;
		_ctrlList ctrlcommit 	0.15;
		} foreach [			960,		860];
		} foreach [
				21,
				22,
				23,
				24
		];
		_ctrl = _display displayctrl 			991;
		_ctrl ctrlsetfade _fadeCargo;
		_ctrl ctrlcommit 	0.15;
		if (_showCargo) then {['TabSelectRight',[_display,		21]] call FUNC(arsenal);};


		_showRight = _showItems || _showCargo;
		_fadeRight = [1,0] select _showRight;
		{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlsetfade _fadeRight;
		_ctrl ctrlcommit 	0.15;
		} foreach [
				1806,
				1802,
				995
		];
	};


	case "TabSelectRight": {
		_display = _this select 0;
		_index = _this select 1;
		_ctrFrameRight = _display displayctrl 		1802;
		_ctrBackgroundRight = _display displayctrl 		995;
		{
		_idc = _x;
		_active = _idc == _index;

		{
		_ctrlList = _display displayctrl (_x + _idc);
		_ctrlList ctrlenable _active;
		_ctrlList ctrlsetfade ([1,0] select _active);
		_ctrlList ctrlcommit 	0.15;
		} foreach [			960,		860];

		_ctrlTab = _display displayctrl (			930 + _idc);
		_ctrlTab ctrlenable (!_active && ctrlfade _ctrlTab == 0);

		if (_active) then {
		_ctrlList = _display displayctrl (			960 + _idc);
		_ctrlLineTabRight = _display displayctrl 		1806;
		_ctrlLineTabRight ctrlsetfade 0;
		_ctrlTabPos = ctrlposition _ctrlTab;
		_ctrlLineTabPosX = (ctrlposition _ctrlList select 0) + (ctrlposition _ctrlList select 2);
		_ctrlLineTabPosY = (_ctrlTabPos select 1);
		_ctrlLineTabRight ctrlsetposition [
		_ctrlLineTabPosX,
		_ctrlLineTabPosY,
		safezoneX + safezoneW - _ctrlLineTabPosX,
		ctrlposition _ctrlTab select 3
		];
		_ctrlLineTabRight ctrlcommit 0;
		ctrlsetfocus _ctrlList;

		_ctrlLoadCargo = _display displayctrl 			991;
		_ctrlListPos = ctrlposition _ctrlList;
		_ctrlListPos set [3,(_ctrlListPos select 3) + (ctrlposition _ctrlLoadCargo select 3)];
		{
		_x ctrlsetposition _ctrlListPos;
		_x ctrlcommit 0;
		} foreach [_ctrFrameRight,_ctrBackgroundRight];

		if (_idc in [		21,		22,		23,		24]) then {
		["SelectItemRight",[_display,_ctrlList,_index]] call FUNC(arsenal);
		};
		};

		_ctrlIcon = _display displayctrl (			900 + _idc);

		_ctrlIcon ctrlshow _active;
		_ctrlIcon ctrlenable (!_active && ctrlfade _ctrlTab == 0);

		_ctrlIconBackground = _display displayctrl (		830 + _idc);
		_ctrlIconBackground ctrlshow _active;
		} foreach [			18,			19,			20,			25,			21,			22,			23,			24];
	};


	case "SelectItem": {
		private ["_ctrlList","_index","_cursel"];
		_display = _this select 0;
		_ctrlList = _this select 1;
		_index = _this select 2;
		_cursel = lbcursel _ctrlList;
		if (_cursel < 0) exitwith {};
		_item = if (ctrltype _ctrlList == 102) then {_ctrlList lnbdata [_cursel,0]} else {_ctrlList lbdata _cursel};
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);

		_ctrlListPrimaryWeapon = _display displayctrl (			960 + 		0);
		_ctrlListSecondaryWeapon = _display displayctrl (			960 + 	1);
		_ctrlListHandgun = _display displayctrl (			960 + 		2);

		switch _index do {
		case 		3: {
		if (_item == "") then {
		removeuniform _center;
		} else {
			sleep 0.1;
			_items = uniformitems _center;
			_center forceadduniform _item;
			{_center additemtouniform _x} foreach _items;
		};


		['SelectItem',[_display,_display displayctrl (			960 + 		17),		17]] spawn FUNC(arsenal);
		};
		case 			4: {
		if (_item == "") then {
		removevest _center;
		} else {
			sleep 0.1;
			_items = vestitems _center;
			_center addvest _item;
			{_center additemtovest _x} foreach _items;
		};
		};
		case 		5: {
		_items = backpackitems _center;
		removebackpack _center;
		if !(_item == "") then {
			sleep 0.1;
			_center addbackpack _item;
			{_center additemtobackpack _x} foreach _items;
		};
		};
		case 		6: {
		if (_item == "") then {removeheadgear _center;} else {sleep 0.1; _center addheadgear _item;};
		};
		case 		7: {
		if (_item == "") then {removegoggles _center} else {sleep 0.1; _center addgoggles _item;};
		};
		case 			8;
		case 		9: {
		if (_item == "") then {
		_weapons = [];
		for "_l" from 0 to (lbsize _ctrlList) do {_weapons set [count _weapons,tolower (_ctrlList lbdata _l)];};
		{
		if (tolower _x in _weapons) then {_center removeweapon _x;};
		} foreach (assigneditems _center);
		} else {sleep 0.1; _center addweapon _item;};
		};
		case 		0: {
		_isDifferentWeapon = (primaryweapon _center call bis_fnc_baseWeapon) != _item;
		if (_isDifferentWeapon) then {
		{_center removemagazines _x} foreach getarray (configfile >> "cfgweapons" >> primaryweapon _center >> "magazines");
		if (_item == "") then {
		_center removeweapon primaryweapon _center;
		} else {
		_compatibleItems = _item call bis_fnc_compatibleItems;
		_weaponAccessories = primaryweaponitems _center - [""];
		[_center,_item,4] call bis_fnc_addweapon;
		{
		_acc = _x;
		if ({_x == _acc} count _compatibleItems > 0) then {sleep 0.1;_center addprimaryweaponitem _acc;};
		} foreach _weaponAccessories;
		};
		};
		};
		case 	1: {
		_isDifferentWeapon = (secondaryweapon _center call bis_fnc_baseWeapon) != _item;
		if (_isDifferentWeapon) then {
		{_center removemagazines _x} foreach getarray (configfile >> "cfgweapons" >> secondaryweapon _center >> "magazines");
		if (_item == "") then {
		_center removeweapon secondaryweapon _center;
		} else {
		_compatibleItems = _item call bis_fnc_compatibleItems;
		_weaponAccessories = secondaryweaponitems _center - [""];
		[_center,_item,2] call bis_fnc_addweapon;
		{
		_acc = _x;
		if ({_x == _acc} count _compatibleItems > 0) then {sleep 0.1;_center addsecondaryweaponitem _acc;};
		} foreach _weaponAccessories;
		};
		};
		};
		case 		2: {
		_isDifferentWeapon = (handgunweapon _center call bis_fnc_baseWeapon) != _item;
		if (_isDifferentWeapon) then {
		{_center removemagazines _x} foreach getarray (configfile >> "cfgweapons" >> handgunweapon _center >> "magazines");
		if (_item == "") then {
		_center removeweapon handgunweapon _center;
		} else {
		_compatibleItems = _item call bis_fnc_compatibleItems;
		_weaponAccessories = handgunitems _center - [""];
		[_center,_item,4] call bis_fnc_addweapon;
		{
		_acc = _x;
		if ({_x == _acc} count _compatibleItems > 0) then {sleep 0.1;_center addhandgunitem _acc;};
		} foreach _weaponAccessories;
		};
		};
		};
		case 			10;
		case 			11;
		case 			12;
		case 		13;
		case 			14: {
		if (_item == "") then {
		_items = [];
		for "_l" from 0 to (lbsize _ctrlList) do {_items set [count _items,tolower (_ctrlList lbdata _l)];};
		{
		if (tolower _x in _items) then {_center unassignitem _x; _center removeitem _x;};
		} foreach (assigneditems _center);
		} else {
		_center linkitem _item;
		};
		};
		case 			15: {
		_face = if (_item == "") then {"Default";} else {_item;};

		[[_center,_face],"bis_fnc_setidentity"] call bis_fnc_mp;
		_center setvariable ["BIS_fnc_arsenal_face",_face];
		};
		case 			16: {
		_center setspeaker _item;
		[[_center,nil,_item],"bis_fnc_setidentity"] call bis_fnc_mp;
		if (ctrlenabled (_display displayctrl (			960 + 			16))) then {
		if !(isnil "BIS_fnc_arsenal_voicePreview") then {terminate BIS_fnc_arsenal_voicePreview;};
		BIS_fnc_arsenal_voicePreview = [] spawn {
		scriptname "BIS_fnc_arsenal_voicePreview";
		sleep 0.6;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_center directsay "CuratorObjectPlaced";
		};
		};
		};
		case 		17: {
		[_center,_item] call bis_fnc_setUnitInsignia;
		};
		case 		18;
		case 		19;
		case 		20;
		case 		25: {
		_accIndex = [
				20,
				19,
				18,
				25
		] find _index;
		switch true do {
		case (ctrlenabled _ctrlListPrimaryWeapon): {
		if (_item != "") then {
			sleep 0.1;
			_center addprimaryweaponitem _item;
		} else {
		_weaponAccessories = _center weaponaccessories primaryweapon _center;
		if (count _weaponAccessories > 0) then {_center removeprimaryweaponitem (_weaponAccessories select _accIndex);};
		};
		};
		case (ctrlenabled _ctrlListSecondaryWeapon): {
		if (_item != "") then {
			sleep 0.1;
			_center addsecondaryweaponitem _item;
		} else {
		_weaponAccessories = _center weaponaccessories secondaryweapon _center;
		if (count _weaponAccessories > 0) then {_center removesecondaryweaponitem (_weaponAccessories select _accIndex);};
		};
		};
		case (ctrlenabled _ctrlListHandgun): {
		if (_item != "") then {
			sleep 0.1;
			_center addhandgunitem _item;
		} else {
		_weaponAccessories = _center weaponaccessories handgunweapon _center;
		if (count _weaponAccessories > 0) then {_center removehandgunitem (_weaponAccessories select _accIndex);};
		};
		};
		};
		};
		};


		if (
		_index in [		3,			4,		5]
		&&
		ctrlenabled (_display displayctrl (			960 + _index))
		) then {
		_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
			_virtualItemCargo =		(missionnamespace call bis_fnc_getVirtualItemCargo) +		(_cargo call bis_fnc_getVirtualItemCargo) +		items _center +		assigneditems _center +		primaryweaponitems _center +		secondaryweaponitems _center +		handgunitems _center +		[uniform _center,vest _center,headgear _center,goggles _center];	_virtualWeaponCargo = [];	{		_weapon = _x call bis_fnc_baseWeapon;		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];		{			private ["_item"];			_item = gettext (_x >> "item");			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

		private ["_ctrlList"];
		_ctrlList = _display displayctrl (			960 + 		21);
		lbclear _ctrlList;
		_itemsCurrent = [];
		_load = 0;
		switch _index do {
		case 		3: {
		_itemsCurrent = uniformitems _center;
		_load = if (uniform _center == "") then {1} else {loaduniform _center};
		};
		case 			4: {
		_itemsCurrent = vestitems _center;
		_load = if (vest _center == "") then {1} else {loadvest _center};
		};
		case 		5: {
		_itemsCurrent = backpackitems _center;
		_load = if (backpack _center == "") then {1} else {loadbackpack _center};
		};
		default {[]};
		};

		_ctrlLoadCargo = _display displayctrl 			991;
		_ctrlLoadCargo progresssetposition _load;


		_magazines = [];
		{
		_cfgWeapon = configfile >> "cfgweapons" >> _x;
		{
		_cfgMuzzle = if (_x == "this") then {_cfgWeapon} else {_cfgWeapon >> _x};
		{
		private ["_item"];
		_item = _x;
		if ((_fullVersion || {"%ALL" in _virtualMagazineCargo} || {{_item == _x} count _virtualMagazineCargo > 0})) then {
		_mag = tolower _item;
		if !(_mag in _magazines) then {
		_magazines set [count _magazines,_mag];
		_value = {_x == _mag} count _itemsCurrent;
		_displayName = gettext (configfile >> "cfgmagazines" >> _mag >> "displayName");
		_displayNameArray = toarray _displayName;
		_tooltip = "";
		if (count _displayNameArray > 20) then {
		_displayNameArray resize 20;
		_displayNameArray = _displayNameArray + toarray "...";
		_tooltip = _displayName;
		};
		_lbAdd = _ctrlList lnbaddrow ["",tostring _displayNameArray,str _value];
		_ctrlList lnbsetdata [[_lbAdd,0],_mag];
		_ctrlList lnbsetvalue [[_lbAdd,0],getnumber (configfile >> "cfgmagazines" >> _mag >> "mass")];
		_ctrlList lnbsetpicture [[_lbAdd,0],gettext (configfile >> "cfgmagazines" >> _mag >> "picture")];
		_ctrlList lbsettooltip [_lbAdd,_tooltip];
		};
		};
		} foreach getarray (_cfgMuzzle >> "magazines");
		} foreach getarray (_cfgWeapon >> "muzzles");
		} foreach (weapons _center - ["Throw","Put"]);
		_ctrlList lbsetcursel (lbcursel _ctrlList max 0);

		_ctrlListActive = controlnull;
		if (ctrlenabled _ctrlList) then {_ctrlListActive = _ctrlList;};



		{
		_ctrlList = _display displayctrl (			960 + _x);
		for "_l" from 0 to (lbsize _ctrlList - 1) do {
		_class = _ctrlList lnbdata [_l,0];
		_ctrlList lnbsettext [[_l,2],str ({_x == _class} count _itemsCurrent)];
		};
		_ctrlList lbsetcursel (lbcursel _ctrlList max 0);
		if (ctrlenabled _ctrlList) then {_ctrlListActive = _ctrlList;};
		} foreach [
				22,
				23,
				24
		];


		if !(isnull _ctrlListActive) then {
		["SelectItemRight",[_display,_ctrlListActive,_index]] call FUNC(arsenal);
		};
		};


		if (
		_index in [		0,	1,		2]
		&&
		ctrlenabled (_display displayctrl (			960 + _index))
		) then {
		private ["_ctrlList"];

		_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
			_virtualItemCargo =		(missionnamespace call bis_fnc_getVirtualItemCargo) +		(_cargo call bis_fnc_getVirtualItemCargo) +		items _center +		assigneditems _center +		primaryweaponitems _center +		secondaryweaponitems _center +		handgunitems _center +		[uniform _center,vest _center,headgear _center,goggles _center];	_virtualWeaponCargo = [];	{		_weapon = _x call bis_fnc_baseWeapon;		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];		{			private ["_item"];			_item = gettext (_x >> "item");			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

		{
		_ctrlList = _display displayctrl (			960 + _x);
		lbclear _ctrlList;
		_ctrlList lbsetcursel -1;
		} foreach [
				20,
				19,
				18,
				25
		];


		_compatibleItems = _item call bis_fnc_compatibleItems;
		{
		private ["_item"];
		_item = _x;
		_itemCfg = configfile >> "cfgweapons" >> _item;
		_scope = if (isnumber (_itemCfg >> "scopeArsenal")) then {getnumber (_itemCfg >> "scopeArsenal")} else {getnumber (_itemCfg >> "scope")};
		if (_scope == 2 && (_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {
		_type = _item call bis_fnc_itemType;
		_idcList = switch (_type select 1) do {
		case "AccessoryMuzzle": {			960 + 		20};
		case "AccessoryPointer": {			960 + 		19};
		case "AccessorySights": {			960 + 		18};
		case "AccessoryBipod": {			960 + 		25};
		default {-1};
		};
		_ctrlList = _display displayctrl _idcList;
		_lbAdd = _ctrlList lbadd gettext (_itemCfg >> "displayName");
		_ctrlList lbsetdata [_lbAdd,_item];
		_ctrlList lbsetpicture [_lbAdd,gettext (_itemCfg >> "picture")];
		if (_fullVersion) then {
		_ctrlList lbsetpictureright [_lbAdd,gettext ((configfile >> "cfgMods" >> gettext (configfile >> "cfgweapons" >> _item >> "dlc")) >> "logo")];
		};
		};
		} foreach _compatibleItems;


		_weapon = switch true do {
		case (ctrlenabled _ctrlListPrimaryWeapon): {primaryweapon _center};
		case (ctrlenabled _ctrlListSecondaryWeapon): {secondaryweapon _center};
		case (ctrlenabled _ctrlListHandgun): {handgunweapon _center};
		default {""};
		};


		_weaponAccessories = _center weaponaccessories _weapon;
		{
		_ctrlList = _display displayctrl (			960 + _x);
		_lbAdd = _ctrlList lbadd format ["<%1>",localize "str_empty"];
		lbsort _ctrlList;
		for "_l" from 0 to (lbsize _ctrlList - 1) do {
		_data = _ctrlList lbdata _l;
		if (_data != "" && {{_data == _x} count _weaponAccessories > 0}) exitwith {_ctrlList lbsetcursel _l;};
		};
		if (lbcursel _ctrlList < 0) then {_ctrlList lbsetcursel 0;};
		} foreach [
				20,
				19,
				18,
				25
		];
		};


		_ctrlLoad = _display displayctrl 			990;
		_ctrlLoad progresssetposition load _center;


		if (ctrlenabled _ctrlList) then {
		_itemCfg = switch _index do {
		case 		5:	{configfile >> "cfgvehicles" >> _item};
		case 		7:		{configfile >> "cfgglasses" >> _item};
		case 			15:		{((configfile >> "cfgfaces") select (_ctrlList lbvalue _cursel)) >> _item};
		case 			16:		{configfile >> "cfgvoice" >> _item};
		case 		17:	{configfile >> "cfgunitinsignia" >> _item};
		case 		21;
		case 		22;
		case 		23;
		case 		24:	{configfile >> "cfgmagazines" >> _item};
		default						{configfile >> "cfgweapons" >> _item};
		};

		["ShowItemInfo",[_itemCfg]] call FUNC(arsenal);
		["ShowItemStats",[_itemCfg]] call FUNC(arsenal);
		};
	};


	case "SelectItemRight": {
		_display = _this select 0;
		_ctrlList = _this select 1;
		_index = _this select 2;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);


		_indexLeft = -1;
		{
		_ctrlListLeft = _display displayctrl (			960 + _foreachindex);
		if (ctrlenabled _ctrlListLeft) exitwith {_indexLeft = _foreachindex;};
		} foreach [			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17];

		_supply = switch _indexLeft do {
		case 		3: {
		gettext (configfile >> "CfgWeapons" >> uniform _center >> "ItemInfo" >> "containerClass")
		};
		case 			4: {
		gettext (configfile >> "CfgWeapons" >> vest _center >> "ItemInfo" >> "containerClass")
		};
		case 		5: {
		backpack _center
		};
		default {0};
		};
		_maximumLoad = getnumber (configfile >> "CfgVehicles" >> _supply >> "maximumLoad");

		_ctrlLoadCargo = _display displayctrl 			991;
		_load = _maximumLoad * (1 - progressposition _ctrlLoadCargo);


		_rows = lnbsize _ctrlList select 0;
		_columns = lnbsize _ctrlList select 1;
		for "_r" from 0 to (_rows - 1) do {
		_mass = _ctrlList lbvalue (_r * _columns);
		_alpha = [1.0,0.25] select (_mass > _load);
		_ctrlList lnbsetcolor [[_r,1],[1,1,1,_alpha]];
		_ctrlList lnbsetcolor [[_r,2],[1,1,1,_alpha]];
		};
	};


	case "ShowItemInfo": {
		_itemCfg = _this select 0;
		if (isclass _itemCfg) then {
		_itemName = if (ctrltype _ctrlList == 102) then {_ctrlList lnbtext [_cursel,1]} else {_ctrlList lbtext _cursel};

		_ctrlInfo = _display displayctrl 		25815;
		_ctrlInfo ctrlsetfade 0;
		_ctrlInfo ctrlcommit 	0.15;

		_ctrlInfoName = _display displayctrl 		24516;
		_ctrlInfoName ctrlsettext _itemName;

		_ctrlInfoAuthor = _display displayctrl 	24517;
		_ctrlInfoAuthor ctrlsettext "";
		[_itemCfg,_ctrlInfoAuthor] call bis_fnc_overviewauthor;


		_ctrlDLC = _display displayctrl 		24715;
		_ctrlDLCBackground = _display displayctrl 	24518;
		_dlc = gettext (_itemCfg >> "dlc");
		if (_dlc != "" && _fullVersion) then {

		_cfgDLC = configfile >> "cfgMods" >> _dlc;
		_logo = gettext (_cfgDLC >> "logo");
		_logoOver = gettext (_cfgDLC >> "logoOver");
		_fieldManualTopicAndHint = getarray (_cfgDLC >> "fieldManualTopicAndHint");
		_dlcColor = getarray (_cfgDLC >> "dlcColor");
		_name = gettext (_cfgDLC >> "name");

		_ctrlDLC ctrlsettooltip _name;
		_ctrlDLC ctrlsettext _logo;
		_ctrlDLC ctrlsetfade 0;
		_ctrlDLC ctrlseteventhandler ["mouseexit",format ["(_this select 0) ctrlsettext '%1';",_logo]];
		_ctrlDLC ctrlseteventhandler ["mouseenter",format ["(_this select 0) ctrlsettext '%1';",_logoOver]];
		_ctrlDLC ctrlseteventhandler ["buttonclick",format ["(%1 + [ctrlparent (_this select 0)]) call bis_fnc_openFieldManual;",_fieldManualTopicAndHint]];
		_ctrlDLCBackground ctrlsetfade 0;
		} else {
		_ctrlDLC ctrlsetfade 1;
		_ctrlDLCBackground ctrlsetfade 1;
		};
		_ctrlDLC ctrlcommit 	0.15;
		_ctrlDLCBackground ctrlcommit 	0.15;
		} else {
		_ctrlInfo = _display displayctrl 		25815;
		_ctrlInfo ctrlsetfade 1;
		_ctrlInfo ctrlcommit 	0.15;

		_ctrlStats = _display displayctrl 		28644;
		_ctrlStats ctrlsetfade 1;
		_ctrlStats ctrlcommit 	0.15;
		};
	};


	case "ShowItemStats": {
		_itemCfg = _this select 0;
		if (isclass _itemCfg) then {
		_ctrlStats = _display displayctrl 		28644;
		_ctrlStatsPos = ctrlposition _ctrlStats;
		_ctrlStatsPos set [0,0];
		_ctrlStatsPos set [1,0];
		_ctrlBackground = _display displayctrl 	27347;
		_barMin = 0.01;
		_barMax = 1;

		_statControls = [
		[		27348,		27353],
		[		27349,		27354],
		[		27350,		27355],
		[		27351,		27356],
		[		27352,		27357]
		];
		_rowH = 1 / (count _statControls + 1);
		_fnc_showStats = {
		_h = _rowH;
		{
		_ctrlStat = _display displayctrl ((_statControls select _foreachindex) select 0);
		_ctrlText = _display displayctrl ((_statControls select _foreachindex) select 1);
		if (count _x > 0) then {
		_ctrlStat progresssetposition (_x select 0);
		_ctrlText ctrlsettext toupper (_x select 1);
		_ctrlText ctrlsetfade 0;
		_ctrlText ctrlcommit 0;

		_h = _h + _rowH;
		} else {
		_ctrlStat progresssetposition 0;
		_ctrlText ctrlsetfade 1;
		_ctrlText ctrlcommit 0;

		};
		} foreach _this;
		_ctrlStatsPos set [1,(_ctrlStatsPos select 3) * (1 - _h)];
		_ctrlStatsPos set [3,(_ctrlStatsPos select 3) * _h];
		_ctrlBackground ctrlsetposition _ctrlStatsPos;
		_ctrlBackground ctrlcommit 0;
		};

		switch _index do {
		case 		0;
		case 	1;
		case 		2: {
		_ctrlStats ctrlsetfade 0;
		_statsExtremes = uinamespace getvariable "bis_fnc_arsenal_weaponStats";
		if !(isnil "_statsExtremes") then {
		_statsMin = _statsExtremes select 0;
		_statsMax = _statsExtremes select 1;

		_stats = [
		[_itemCfg],
			["reloadtime","dispersion","maxrange","hit","mass","initSpeed"],	[true,true,true,true,false,false],
		_statsMin
		] call bis_fnc_configExtremes;
		_stats = _stats select 1;

		_statReloadSpeed = linearConversion [_statsMin select 0,_statsMax select 0,_stats select 0,_barMax,_barMin];
		_statDispersion = linearConversion [_statsMin select 1,_statsMax select 1,_stats select 1,_barMax,_barMin];
		_statMaxRange = linearConversion [_statsMin select 2,_statsMax select 2,_stats select 2,_barMin,_barMax];
		_statHit = linearConversion [_statsMin select 3,_statsMax select 3,_stats select 3,_barMin,_barMax];
		_statMass = linearConversion [_statsMin select 4,_statsMax select 4,_stats select 4,_barMin,_barMax];
		_statInitSpeed = linearConversion [_statsMin select 5,_statsMax select 5,_stats select 5,_barMin,_barMax];
		if (getnumber (_itemCfg >> "type") == 4) then {
		[
		[],
		[],
		[_statMaxRange,localize "str_a3_rscdisplayarsenal_stat_range"],
		[_statHit,localize "str_a3_rscdisplayarsenal_stat_impact"],
		[_statMass,localize "str_a3_rscdisplayarsenal_stat_weight"]
		] call _fnc_showStats;
		} else {
		_statHit = sqrt(_statHit^2 * _statInitSpeed);
		[
		[_statReloadSpeed,localize "str_a3_rscdisplayarsenal_stat_rof"],
		[_statDispersion,localize "str_a3_rscdisplayarsenal_stat_dispersion"],
		[_statMaxRange,localize "str_a3_rscdisplayarsenal_stat_range"],
		[_statHit,localize "str_a3_rscdisplayarsenal_stat_impact"],
		[_statMass,localize "str_a3_rscdisplayarsenal_stat_weight"]
		] call _fnc_showStats;
		};
		};
		};
		case 		3;
		case 			4;
		case 		5;
		case 		6: {
		_ctrlStats ctrlsetfade 0;
		_statsExtremes = uinamespace getvariable "bis_fnc_arsenal_equipmentStats";
		if !(isnil "_statsExtremes") then {
		_statsMin = _statsExtremes select 0;
		_statsMax = _statsExtremes select 1;

		_stats = [
		[_itemCfg],
			["armor","maximumLoad","mass"],	[true,false,false],
		_statsMin
		] call bis_fnc_configExtremes;
		_stats = _stats select 0;

		_statArmor = linearConversion [_statsMin select 0,_statsMax select 0,_stats select 0,_barMin,_barMax];
		_statMaximumLoad = linearConversion [_statsMin select 1,_statsMax select 1,_stats select 1,_barMin,_barMax];
		_statMass = linearConversion [_statsMin select 2,_statsMax select 2,_stats select 2,_barMin,_barMax];

		if (getnumber (_itemCfg >> "isbackpack") == 1) then {_statArmor = _barMin;};

		[
		[],
		if (_item == "H_Beret_blk") then {[0.95,localize "STR_difficulty3"]} else {[]},
		[_statArmor,localize "str_a3_rscdisplayarsenal_stat_armor"],
		[_statMaximumLoad,localize "str_a3_rscdisplayarsenal_stat_load"],
		[_statMass,localize "str_a3_rscdisplayarsenal_stat_weight"]
		] call _fnc_showStats;
		};
		};
		default {
		_ctrlStats ctrlsetfade 1;
		};
		};
		_ctrlStats ctrlcommit 	0.15;
		} else {
		_ctrlStats = _display displayctrl 		28644;
		_ctrlStats ctrlsetfade 1;
		_ctrlStats ctrlcommit 	0.15;
		};
	};


	case "ShowItem": {
		private ["_display","_ctrlList","_index","_cursel","_item","_center","_action"];
		_display = _this select 0;
		_ctrlList = _this select 1;
		_index = _this select 2;
		_cursel = lbcursel _ctrlList;
		if (_cursel < 0) exitwith {};
		_item = _ctrlList lbdata _cursel;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);

		_action = "";
		switch _index do {

		case 		3;
		case 			4;
		case 		5;
		case 		6;
		case 		7;
		case 			8: {
		_action = "Stand";
		};
		case 		9: {
		_action = if (_item == "") then {"Civil"} else {"Binoculars"};
		};
		case 		0: {
		_center selectweapon primaryweapon _center;
		_action = if (_item == "") then {"Civil"} else {"PrimaryWeapon"};
		};
		case 	1: {
		_center selectweapon secondaryweapon _center;
		_action = if (_item == "") then {"Civil"} else {"SecondaryWeapon"};
		};
		case 		2: {
		_center selectweapon handgunweapon _center;
		_action = if (_item == "") then {"Civil"} else {"HandGunOn"};
		};
		case 			10;
		case 			11;
		case 			12;
		case 		13;
		case 			14;
		case 			15;
		case 			16;
		case 		18;
		case 		19;
		case 		20;
		case 		25: {
		};
		case 		17: {
		_action = "Salute";
		};
		};

		if (_action != "" && _action != BIS_fnc_arsenal_action) then {
		_center playactionnow _action;
		BIS_fnc_arsenal_action = _action;
		};
	};


	case "KeyDown": {
		_display = _this select 0;
		_key = _this select 1;
		_shift = _this select 2;
		_ctrl = _this select 3;
		_alt = _this select 4;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_return = false;
		_ctrlTemplate = _display displayctrl 		35919;
		_inTemplate = ctrlfade _ctrlTemplate == 0;

		switch true do {
		case (_key == 0x01): {
		if (_inTemplate) then {
		_ctrlTemplate ctrlsetfade 1;
		_ctrlTemplate ctrlcommit 0;
		_ctrlTemplate ctrlenable false;

		_ctrlMouseBlock = _display displayctrl 		898;
		_ctrlMouseBlock ctrlenable false;
		} else {
		if (_fullVersion) then {["buttonClose",[_display]] spawn FUNC(arsenal);} else {_display closedisplay 2;};
		};
		_return = true;
		};


		case (_key in [0x1C    ,0x9C    ]): {
		_ctrlTemplate = _display displayctrl 		35919;
		if (ctrlfade _ctrlTemplate == 0) then {
		if (BIS_fnc_arsenal_type == 0) then {
		["buttonTemplateOK",[_display]] spawn FUNC(arsenal);
		} else {
		["buttonTemplateOK",[_display]] spawn bis_fnc_garage;
		};
		_return = true;
		};
		};


		case (_key == 0x02);
		case (_key == 0x03);
		case (_key == 0x04);
		case (_key == 0x05);
		case (_key == 0x06);
		case (_key == 0x02);
		case (_key == 0x08);
		case (_key == 0x09);
		case (_key == 0x0A);
		case (_key == 0x0B): {
		_return = true;
		};


		case (_key == 0x0F): {
		_idc = -1;
		{
		_ctrlTab = _display displayctrl (			930 + _x);
		if !(ctrlenabled _ctrlTab) exitwith {_idc = _x;};
		} foreach [			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17];
		_idcCount = {!isnull (_display displayctrl (			930 + _x))} count [			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17];
		_idc = if (_ctrl) then {(_idc - 1 + _idcCount) % _idcCount} else {(_idc + 1) % _idcCount};
		if (BIS_fnc_arsenal_type == 0) then {
		["TabSelectLeft",[_display,_idc]] call FUNC(arsenal);
		} else {
		["TabSelectLeft",[_display,_idc]] call bis_fnc_garage;
		};
		_return = true;
		};


		case (_key == 0x2E): {
		_mode = if (_shift) then {"config"} else {"init"};
		if (BIS_fnc_arsenal_type == 0) then {
		if (_ctrl) then {['buttonExport',[_display,_mode]] call FUNC(arsenal);};
		} else {
		if (_ctrl) then {['buttonExport',[_display,_mode]] call bis_fnc_garage;};
		};
		};

		case (_key == 0x2F): {
		if (BIS_fnc_arsenal_type == 0) then {
		if (_ctrl) then {['buttonImport',[_display]] call FUNC(arsenal);};
		} else {
		if (_ctrl) then {['buttonImport',[_display]] call bis_fnc_garage;};
		};
		};

		case (_key == 0x1F): {
		if (_ctrl) then {['buttonSave',[_display]] call FUNC(arsenal);};
		};

		case (_key == 0x18): {
		if (_ctrl) then {['buttonLoad',[_display]] call FUNC(arsenal);};
		};

		case (_key == 0x13): {
		if (_ctrl) then {
		if (BIS_fnc_arsenal_type == 0) then {
		if (_shift) then {
		_soldiers = [];
		{
		_soldiers set [count _soldiers,configname _x];
		} foreach ("isclass _x && getnumber (_x >> 'scope') > 1 && gettext (_x >> 'simulation') == 'soldier'" configclasses (configfile >> "cfgvehicles"));
		[_center,_soldiers call bis_fnc_selectrandom] call FUNC(loadInventory);
		["ListSelectCurrent",[_display]] call FUNC(arsenal);
		}else {
		['buttonRandom',[_display]] call FUNC(arsenal);
		};
		} else {
		['buttonRandom',[_display]] call bis_fnc_garage;
		};
		};
		};

		case (_key == 0x0E                 && !_inTemplate): {
		['buttonInterface',[_display]] call FUNC(arsenal);
		_return = true;
		};


		case (_key in (actionkeys "timeInc")): {
		if (acctime == 0) then {setacctime 1;};
		_return = true;
		};
		case (_key in (actionkeys "timeDec")): {
		if (acctime != 0) then {setacctime 0;};
		_return = true;

		};


		case (_key in (actionkeys "nightvision") && !_inTemplate): {
		_mode = missionnamespace getvariable ["BIS_fnc_arsenal_visionMode",-1];
		_mode = (_mode + 1) % 3;
		missionnamespace setvariable ["BIS_fnc_arsenal_visionMode",_mode];
		switch _mode do {

		case 0: {
		camusenvg false;
		false setCamUseTi 0;
		};

		case 1: {
		camusenvg true;
		false setCamUseTi 0;
		};

		default {
		camusenvg false;
		true setCamUseTi 0;
		};
		};
		playsound ["RscDisplayCurator_visionMode",true];
		_return = true;

		};
		};
		_return
	};

	case "buttonCargo": {
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_display = _this select 0;
		_add = _this select 1;

		_selected = -1;
		{
		_ctrlList = _display displayctrl (			960 + _x);
		if (ctrlenabled _ctrlList) exitwith {_selected = _x;};
		} foreach [			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17];

		_ctrlList = ctrlnull;
		_lbcursel = -1;
		{
		_ctrlList = _display displayctrl (			960 + _x);
		if (ctrlenabled _ctrlList) exitwith {_lbcursel = lbcursel _ctrlList;};
		} foreach [			18,			19,			20,			25,			21,			22,			23,			24];
		_item = _ctrlList lnbdata [_lbcursel,0];
		_load = 0;
		_items = [];
		switch _selected do {
		case 		3: {
		if (_add > 0) then {sleep 0.1;_center additemtouniform _item;} else {_center removeitemfromuniform _item;};
		_load = loaduniform _center;
		_items = uniformitems _center;
		};
		case 			4: {
		if (_add > 0) then {sleep 0.1;_center additemtovest _item;} else {_center removeitemfromvest _item;};
		_load = loadvest _center;
		_items = vestitems _center;
		};
		case 		5: {
		if (_add > 0) then {sleep 0.1;_center additemtobackpack _item;} else {_center removeitemfrombackpack _item;};
		_load = loadbackpack _center;
		_items = backpackitems _center;
		};
		};

		_ctrlLoadCargo = _display displayctrl 			991;
		_ctrlLoadCargo progresssetposition _load;

		_value = {_x == _item} count _items;

		_ctrlList lnbsettext [[_lbcursel,2],str _value];

		["SelectItemRight",[_display,_ctrlList,_index]] call FUNC(arsenal);
	};


	case "buttonTemplateOK": {
		_display = _this select 0;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_hideTemplate = true;

		_ctrlTemplateName = _display displayctrl 		35020;
		if (ctrlenabled _ctrlTemplateName) then {

		[
		_center,
		[profilenamespace,ctrltext _ctrlTemplateName],
		[
		_center getvariable ["BIS_fnc_arsenal_face",face _center],
		speaker _center,
		_center call bis_fnc_getUnitInsignia
		]
		] call FUNC(saveInventory);
		} else {

		_ctrlTemplateValue = _display displayctrl 		35119;
		if ((_ctrlTemplateValue lbvalue lnbcurselrow _ctrlTemplateValue) >= 0) then {
		_inventory = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
		[_center,[profilenamespace,_inventory]] call FUNC(loadInventory);


		_ctrlTemplateValue = _display displayctrl 		35119;
		_data = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
		_name = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
		_nameID = _data find _name;
		if (_nameID >= 0) then {
		_inventory = _data select (_nameID + 1);
		_inventoryCustom = _inventory select 10;
		_center setface (_inventoryCustom select 0);
		_center setvariable ["BIS_fnc_arsenal_face",(_inventoryCustom select 0)];
		_center setspeaker (_inventoryCustom select 1);
		[_center,_inventoryCustom select 2] call bis_fnc_setUnitInsignia;
		};

		["ListSelectCurrent",[_display]] call FUNC(arsenal);
		} else {
		_hideTemplate = false;
		};
		};
		if (_hideTemplate) then {
		_ctrlTemplate = _display displayctrl 		35919;
		_ctrlTemplate ctrlsetfade 1;
		_ctrlTemplate ctrlcommit 0;
		_ctrlTemplate ctrlenable false;

		_ctrlMouseBlock = _display displayctrl 		898;
		_ctrlMouseBlock ctrlenable false;
		};
	};


	case "buttonTemplateCancel": {
		_display = _this select 0;

		_ctrlTemplate = _display displayctrl 		35919;
		_ctrlTemplate ctrlsetfade 1;
		_ctrlTemplate ctrlcommit 0;
		_ctrlTemplate ctrlenable false;

		_ctrlMouseBlock = _display displayctrl 		898;
		_ctrlMouseBlock ctrlenable false;
	};


	case "buttonTemplateDelete": {
		_display = _this select 0;
		_ctrlTemplateValue = _display displayctrl 		35119;
		_cursel = lnbcurselrow _ctrlTemplateValue;
		_name = _ctrlTemplateValue lnbtext [_cursel,0];
		[_center,[profilenamespace,_name],nil,true] call (uinamespace getvariable ([QFUNC(saveInventory),"bis_fnc_saveVehicle"] select BIS_fnc_arsenal_type));
		['showTemplates',[_display]] call (uinamespace getvariable ([QFUNC(arsenal),"bis_fnc_garage"] select BIS_fnc_arsenal_type));
		_ctrlTemplateValue lnbsetcurselrow (_cursel max (lbsize _ctrlTemplateValue - 1));

		["templateSelChanged",[_display]] call FUNC(arsenal);
	};


	case "templateSelChanged": {
		_display = _this select 0;

		_ctrlTemplateValue = _display displayctrl 		35119;
		_ctrlTemplateName = _display displayctrl 		35020;
		_ctrlTemplateName ctrlsettext (_ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0]);

		_cursel = lnbcurselrow _ctrlTemplateValue;

		_ctrlTemplateButtonOK = _display displayctrl 		36019;
		_ctrlTemplateButtonOK ctrlenable (_cursel >= 0 && (_ctrlTemplateValue lbvalue _cursel) >= 0);

		_ctrlTemplateButtonDelete = _display displayctrl 	36021;
		_ctrlTemplateButtonDelete ctrlenable (_cursel >= 0);
	};


	case "showTemplates": {
		_display = _this select 0;
		_ctrlTemplateValue = _display displayctrl 		35119;
		lnbclear _ctrlTemplateValue;
		_data = profilenamespace getvariable ["bis_fnc_saveInventory_data",[]];
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);

			_virtualItemCargo =		(missionnamespace call bis_fnc_getVirtualItemCargo) +		(_cargo call bis_fnc_getVirtualItemCargo) +		items _center +		assigneditems _center +		primaryweaponitems _center +		secondaryweaponitems _center +		handgunitems _center +		[uniform _center,vest _center,headgear _center,goggles _center];	_virtualWeaponCargo = [];	{		_weapon = _x call bis_fnc_baseWeapon;		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];		{			private ["_item"];			_item = gettext (_x >> "item");			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

		for "_i" from 0 to (count _data - 1) step 2 do {
		_name = _data select _i;
		_inventory = _data select (_i + 1);

		_inventoryWeapons = [
		(_inventory select 5),
		(_inventory select 6 select 0),
		(_inventory select 7 select 0),
		(_inventory select 8 select 0)
		] - [""];
		_inventoryMagazines = (
		(_inventory select 0 select 1) +
		(_inventory select 1 select 1) +
		(_inventory select 2 select 1)
		) - [""];
		_inventoryItems = (
		[_inventory select 0 select 0] + (_inventory select 0 select 1) +
		[_inventory select 1 select 0] + (_inventory select 1 select 1) +
		(_inventory select 2 select 1) +
		[_inventory select 3] +
		[_inventory select 4] +
		(_inventory select 6 select 1) +
		(_inventory select 7 select 1) +
		(_inventory select 8 select 1) +
		(_inventory select 9)
		) - [""];
		_inventoryBackpacks = [_inventory select 2 select 0] - [""];


		_lbAdd = _ctrlTemplateValue lnbaddrow [_name];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,1],gettext (configfile >> "cfgweapons" >> (_inventory select 6 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,2],gettext (configfile >> "cfgweapons" >> (_inventory select 7 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,3],gettext (configfile >> "cfgweapons" >> (_inventory select 8 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,4],gettext (configfile >> "cfgweapons" >> (_inventory select 0 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,5],gettext (configfile >> "cfgweapons" >> (_inventory select 1 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,6],gettext (configfile >> "cfgvehicles" >> (_inventory select 2 select 0) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,7],gettext (configfile >> "cfgweapons" >> (_inventory select 3) >> "picture")];
		_ctrlTemplateValue lnbsetpicture [[_lbAdd,8],gettext (configfile >> "cfgglasses" >> (_inventory select 4) >> "picture")];

		if (
		{_item = _x; !(_fullVersion || {"%ALL" in _virtualWeaponCargo} || {{_item == _x} count _virtualWeaponCargo > 0}) || !isclass(configfile >> "cfgweapons" >> _item)} count _inventoryWeapons > 0
		||
		{_item = _x; !(_fullVersion || {"%ALL" in _virtualItemCargo + _virtualMagazineCargo} || {{_item == _x} count _virtualItemCargo + _virtualMagazineCargo > 0}) || {isclass(configfile >> _x >> _item)} count ["cfgweapons","cfgglasses","cfgmagazines"] == 0} count _inventoryMagazines > 0
		||
		{_item = _x; !(_fullVersion || {"%ALL" in _virtualItemCargo + _virtualMagazineCargo} || {{_item == _x} count _virtualItemCargo + _virtualMagazineCargo > 0}) || {isclass(configfile >> _x >> _item)} count ["cfgweapons","cfgglasses","cfgmagazines"] == 0} count _inventoryItems > 0
		||
		{_item = _x; !(_fullVersion || {"%ALL" in _virtualBackpackCargo} || {{_item == _x} count _virtualBackpackCargo > 0}) || !isclass(configfile >> "cfgvehicles" >> _item)} count _inventoryBackpacks > 0
		) then {
		_ctrlTemplateValue lnbsetcolor [[_lbAdd,0],[1,1,1,0.25]];
		_ctrlTemplateValue lbsetvalue [_lbAdd,-1];
		};
		};

		["templateSelChanged",[_display]] call FUNC(arsenal);
	};


	case "buttonImport": {
		startloadingscreen [""];
		_display = _this select 0;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);

			_virtualItemCargo =		(missionnamespace call bis_fnc_getVirtualItemCargo) +		(_cargo call bis_fnc_getVirtualItemCargo) +		items _center +		assigneditems _center +		primaryweaponitems _center +		secondaryweaponitems _center +		handgunitems _center +		[uniform _center,vest _center,headgear _center,goggles _center];	_virtualWeaponCargo = [];	{		_weapon = _x call bis_fnc_baseWeapon;		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];		{			private ["_item"];			_item = gettext (_x >> "item");			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

		_disabledItems = [];

		_import = copyfromclipboard;
		_importArray = [_import," 	;='""" + tostring [13,10]] call bis_fnc_splitString;

		if (count _importArray == 1) then {

		_class = _importArray select 0;
		if (isclass (configfile >> "cfgvehicles" >> _class)) then {[_center,_class] call FUNC(loadInventory);};
		} else {

		_importArray = _importArray + [""];
		_to = 1;
		{
		_item = _importArray select _foreachindex + 1;
		switch tolower _x do {
			sleep 0.1;
			case "to": {_to = parsenumber _item;};
			case "removeallweapons": {removeallweapons _center;};
			case "removeallitems": {removeallitems _center;};
			case "removeallassignedItems": {removeallassignedItems _center;};
			case "removeuniform": {removeuniform _center;};
			case "removevest": {removevest _center;};
			case "removebackpack": {removebackpack _center;};
			case "removeheadgear": {removeheadgear _center;};
			case "removegoggles": {removegoggles _center;};
			case "forceadduniform";
			case "adduniform": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center forceadduniform _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addvest": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center addvest _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addbackpack": {
			if ((_fullVersion || {"%ALL" in _virtualBackpackCargo} || {{_item == _x} count _virtualBackpackCargo > 0})) then {_center addbackpack _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addheadgear": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center addheadgear _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addgoggles": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center addgoggles _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};

			case "additemtouniform": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo + _virtualMagazineCargo} || {{_item == _x} count _virtualItemCargo + _virtualMagazineCargo > 0})) then {
			for "_n" from 1 to _to do {_center additemtouniform _item;};
			} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			_to = 1;
			};
			case "additemtovest": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo + _virtualMagazineCargo} || {{_item == _x} count _virtualItemCargo + _virtualMagazineCargo > 0})) then {
			for "_n" from 1 to _to do {_center additemtovest _item;};
			} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			_to = 1;
			};
			case "additemtobackpack": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo + _virtualMagazineCargo} || {{_item == _x} count _virtualItemCargo + _virtualMagazineCargo > 0})) then {
			for "_n" from 1 to _to do {_center additemtobackpack _item;};
			} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			_to = 1;
			};

			case "addweapon": {
			if ((_fullVersion || {"%ALL" in _virtualWeaponCargo} || {{_item == _x} count _virtualWeaponCargo > 0})) then {_center addweapon _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addprimaryweaponitem": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center addprimaryweaponitem _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addsecondaryweaponitem": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center addsecondaryweaponitem _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "addhandgunitem": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center addhandgunitem _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};

			case "addmagazine": {
			if ((_fullVersion || {"%ALL" in _virtualMagazineCargo} || {{_item == _x} count _virtualMagazineCargo > 0})) then {_center addmagazine _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "additem": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center additem _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "assignitem": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center assignitem _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};
			case "linkitem": {
			if ((_fullVersion || {"%ALL" in _virtualItemCargo} || {{_item == _x} count _virtualItemCargo > 0})) then {_center linkItem _item;} else {if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};};
			};

			case "setface": {
			if (_fullVersion) then {_center setface _item; _center setvariable ["BIS_fnc_arsenal_face",_item];};
			};
			case "setspeaker": {
			if (_fullVersion) then {_center setspeaker _item;};
			};
			case "bis_fnc_setunitinsignia": {
			if (_fullVersion) then {[_center,_importArray select ((_foreachindex - 3) max 0)] call bis_fnc_setunitinsignia;};
			};
		};
		} foreach _importArray;
		};


		if (count _disabledItems > 0) then {
		['showMessage',[_display,localize "STR_A3_RscDisplayArsenal_message_unavailable"]] call FUNC(arsenal);
		};

		["ListSelectCurrent",[_display]] call FUNC(arsenal);

		endloadingscreen;
	};


	case "buttonExport": {
		_display = _this select 0;
		_exportMode = _this select 1;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);

		_export = [_center,_exportMode,_fullVersion] call bis_fnc_exportInventory;
		_export spawn {copytoclipboard _this;};
		['showMessage',[_display,localize "STR_a3_RscDisplayArsenal_message_clipboard"]] call FUNC(arsenal);
	};


	case "buttonLoad": {
		_display = _this select 0;
		['showTemplates',[_display]] call (uinamespace getvariable ([QFUNC(arsenal),"bis_fnc_garage"] select BIS_fnc_arsenal_type));

		_ctrlTemplate = _display displayctrl 		35919;
		_ctrlTemplate ctrlsetfade 0;
		_ctrlTemplate ctrlcommit 0;
		_ctrlTemplate ctrlenable true;

		_ctrlMouseBlock = _display displayctrl 		898;
		_ctrlMouseBlock ctrlenable true;
		ctrlsetfocus _ctrlMouseBlock;

		{
		(_display displayctrl _x) ctrlsettext localize "str_disp_int_load";
		} foreach [		34619,		36019];
		{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlshow false;
		_ctrl ctrlenable false;
		} foreach [		34621,		35020];
		_ctrlTemplateValue = _display displayctrl 		35119;
		if (lnbcurselrow _ctrlTemplateValue < 0) then {_ctrlTemplateValue lnbsetcurselrow 0;};
		ctrlsetfocus _ctrlTemplateValue;
	};


	case "buttonSave": {
		_display = _this select 0;
		['showTemplates',[_display]] call (uinamespace getvariable ([QFUNC(arsenal),"bis_fnc_garage"] select BIS_fnc_arsenal_type));

		_ctrlTemplate = _display displayctrl 		35919;
		_ctrlTemplate ctrlsetfade 0;
		_ctrlTemplate ctrlcommit 0;
		_ctrlTemplate ctrlenable true;

		_ctrlMouseBlock = _display displayctrl 		898;
		_ctrlMouseBlock ctrlenable true;

		{
		(_display displayctrl _x) ctrlsettext localize "str_disp_int_save";
		} foreach [		34619,		36019];
		{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlshow true;
		_ctrl ctrlenable true;
		} foreach [		34621,		35020];

		_ctrlTemplateName = _display displayctrl 		35020;
		ctrlsetfocus _ctrlTemplateName;

		_ctrlTemplateValue = _display displayctrl 		35119;
		_ctrlTemplateButtonOK = _display displayctrl 		36019;
		_ctrlTemplateButtonOK ctrlenable true;
		_ctrlTemplateButtonDelete = _display displayctrl 	36021;
		_ctrlTemplateButtonDelete ctrlenable ((lnbsize _ctrlTemplateValue select 0) > 0);

		['showMessage',[_display,localize "STR_A3_RscDisplayArsenal_message_save"]] call FUNC(arsenal);
	};


	case "buttonRandom": {
		_display = _this select 0;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);


		{
		_ctrlList = _display displayctrl (			960 + _x);
		_ctrlList lbsetcursel floor random (lbsize _ctrlList);
		} foreach 	[			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17,			18,			19,			20,			25,			21,			22,			23,			24];


		{
		_weaponID = _foreachindex;
		{
		_compatibleItems = getarray (_x >> "compatibleItems") + [""];
		_acc = _compatibleItems call bis_fnc_selectrandom;
		if (_acc != "") then {
		switch _weaponID do {
		case 0: {_center addprimaryweaponitem _acc;};
		case 1: {_center addsecondaryweaponitem _acc;};
		case 2: {_center addhandgunitem _acc;};
		};
		};
		} foreach ("isclass _x" configclasses (configfile >> "cfgweapons" >> _x >> "WeaponSlotsInfo"));
		} foreach [
		primaryweapon _center,
		secondaryweapon _center,
		handgunweapon _center
		];
	};


	case "buttonInterface": {
		_display = _this select 0;
		_show = !ctrlshown (_display displayctrl 		44046);
		{
		_tab = _x;
		{
		_ctrl = _display displayctrl (_tab + _x);
		_ctrl ctrlshow _show;
		_ctrl ctrlcommit 	0.15;
		} foreach [
					900,
					930,
					960
		];
		_ctrl = _display displayctrl (_tab + 		860);
		_pos = if (_show) then {ctrlposition (_display displayctrl (_tab + 			960))} else {[0,0,0,0]};
		_ctrl ctrlsetposition _pos;
		_ctrl ctrlcommit 0;
		} foreach 	[			0,		1,			2,			3,				4,			5,			6,			7,				8,			9,				10,				11,				12,			13,				14,				15,				16,			17,			18,			19,			20,			25,			21,			22,			23,			24];
		{
		_ctrl = _display displayctrl _x;
		_ctrl ctrlshow _show;
		_ctrl ctrlcommit 	0.15;
		} foreach [
				44046,
					1800,
					1801,
				1802,
					1803,
				1804,
			1805,
				1806,
					900,
				830,
					930,
					960,
					990,
					991,
				994,
				995,
				28644,
			24518,
				24715,
					27903
		];
	};


	case "buttonSpace": {
		_ctrlButton = _this select 0;
		_display = ctrlparent _ctrlButton;
		_buttonID = [
				26803,
				26804
		] find (ctrlidc _ctrlButton);
		_function = [QFUNC(arsenal),"bis_fnc_garage"] select _buttonID;
		BIS_fnc_arsenal_toggleSpace = true;
		_display closedisplay 2;

		_function spawn {
		["Open",true] call (uinamespace getvariable _this);
		};
	};


	case "buttonOK": {
		_display = _this select 0;
		_display closedisplay 2;

		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;
	};


	case "buttonClose": {
		_display = _this select 0;
		_message = if (missionname == "Arsenal") then {
		[
		localize "STR_SURE",
		localize "STR_disp_arcmap_exit",
		nil,
		true,
		_display,
		true
		] call bis_fnc_guimessage;
		} else {
		true
		};
		if (_message) then {
		_display closedisplay 2;
		if (missionname == "Arsenal") then {endmission "end1";};
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;
		};
	};


	case "showMessage": {
		if !(isnil {missionnamespace getvariable "BIS_fnc_arsenal_message"}) then {terminate (missionnamespace getvariable "BIS_fnc_arsenal_message")};

		_spawn = _this spawn {
		disableserialization;
		_display = _this select 0;
		_message = _this select 1;

		_ctrlMessage = _display displayctrl 			996;
		_ctrlMessage ctrlsettext _message;
		_ctrlMessage ctrlsetfade 1;
		_ctrlMessage ctrlcommit 0;
		_ctrlMessage ctrlsetfade 0;
		_ctrlMessage ctrlcommit 	0.15;
		uisleep 5;
		_ctrlMessage ctrlsetfade 1;
		_ctrlMessage ctrlcommit 	0.15;
		};
		missionnamespace setvariable ["BIS_fnc_arsenal_message",_spawn];
	};



	case "AmmoboxInit": {
		private ["_box","_allowAll"];
		_box = [_this,0,objnull,[objnull]] call bis_fnc_param;
		_allowAll = [_this,1,false,[false]] call bis_fnc_param;
		_condition = [_this,2,{true},[{}]] call bis_fnc_param;

		_box setvariable ["bis_fnc_arsenal_condition",_condition,true];

		if (_allowAll) then {
		[_box,true,true,false] call bis_fnc_addVirtualWeaponCargo;
		[_box,true,true,false] call bis_fnc_addVirtualMagazineCargo;
		[_box,true,true,false] call bis_fnc_addVirtualItemCargo;
		[_box,true,true,false] call bis_fnc_addVirtualBackpackCargo;
		};
		[["AmmoboxServer",_box,true],QFUNC(arsenal),false] call bis_fnc_mp;
	};

	case "AmmoboxExit": {
		private ["_box"];
		_box = [_this,0,objnull,[objnull]] call bis_fnc_param;
		[["AmmoboxServer",_box,false],QFUNC(arsenal),false] call bis_fnc_mp;
	};

	case "AmmoboxServer": {
		_box = [_this,0,objnull,[objnull]] call bis_fnc_param;
		_add = [_this,1,true,[true]] call bis_fnc_param;

		_boxes = missionnamespace getvariable ["bis_fnc_arsenal_boxes",[]];
		_boxes = _boxes - [_box];
		if (_add) then {_boxes = _boxes + [_box];};
		missionnamespace setvariable ["bis_fnc_arsenal_boxes",_boxes];
		publicvariable "bis_fnc_arsenal_boxes";

		["AmmoboxLocal",QFUNC(arsenal),true,isnil "bis_fnc_arsenal_ammoboxServer"] call bis_fnc_mp;
		bis_fnc_arsenal_ammoboxServer = true;
	};

	case "AmmoboxLocal": {
		_boxes = missionnamespace getvariable ["bis_fnc_arsenal_boxes",[]];
		{
			if (isnil {_x getvariable "bis_fnc_arsenal_action"}) then {
			_action = _x addaction [
			localize "STR_A3_Arsenal",
			{
			_box = _this select 0;
			_unit = _this select 1;
			["Open",[nil,_box,_unit]] call FUNC(arsenal);
			},
			[],
			6,
			true,
			false,
			"",
			"
									_cargo = _target getvariable ['bis_addVirtualWeaponCargo_cargo',[[],[],[],[]]];
									if ({count _x > 0} count _cargo == 0) then {
										_target removeaction (_target getvariable ['bis_fnc_arsenal_action',-1]);
										_target setvariable ['bis_fnc_arsenal_action',nil];
									};
									_condition = _target getvariable ['bis_fnc_arsenal_condition',{true}];
									alive _target && {_target distance _this < 5} && {call _condition}
								"
			];
			_x setvariable ["bis_fnc_arsenal_action",_action];
			};
		} foreach _boxes;
	};
};