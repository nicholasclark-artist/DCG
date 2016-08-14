class CfgPatches {
	class ADDON {
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {"cba_common","cba_xeh",QUOTE(MAIN_ADDON)};
		author = "SENSEI";
		name = DOUBLES(PREFIX,ADDON);
		url = URL;
		VERSION_CONFIG;
	};
};