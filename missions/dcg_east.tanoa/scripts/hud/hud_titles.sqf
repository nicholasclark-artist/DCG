#define true 1
#define false 0

class infomessage {
	idd = 101;
	movingEnable=0;
	duration = 1000000000;
	fadein=0;
	name="infomessage";
	controlsBackground[] = {"crewtext"};
	onLoad = "uiNamespace setVariable ['crewdisplay', _this select 0];";
	onunLoad = "uiNamespace setVariable ['crewdisplay', objnull];";
	class crewtext {
		idc = 102;
		type = CT_STRUCTURED_TEXT;
		style = ST_RIGHT;
		x = safeZoneX;
		y = (safeZoneY + 0.4);
		w = safeZoneW;
		h = 0.5;
		size = 0.02;
		colorBackground[] = {0,0,0,0};
		colortext[] = {0,0,0,0.8};
		text ="";
		class Attributes {
			align = "right";
			valign = "middle";
			size = "1";
			shadow = true;
			shadowColor = "#2D2D2D";
		};
	};
};

class infomessage2 {
	idd = 103;
	movingEnable=1;
	duration = 10000000;
	fadein=0;
	name="infomessage2";
	controlsBackground[] = {"platoontext"};
	onLoad = "uiNamespace setVariable ['platoondisplay', _this select 0];";
	onunLoad = "uiNamespace setVariable ['platoondisplay', objnull];";
	class platoontext {
		idc = 104;
		type = CT_STRUCTURED_TEXT;
		style = ST_LEFT;
		x = safeZoneX;
		y = (safeZoneY + 0.03);
		w = safeZoneW;
		h = 1.5;
		size = 0.02;
		colorBackground[] = {0,0,0,0};
		colortext[] = {0,0,0,0.8};
		text ="";
		class Attributes {
			align = "left";
			valign = "middle";
			size = "1";
			shadow = true;
			shadowColor = "#2D2D2D";
		};
	};
};