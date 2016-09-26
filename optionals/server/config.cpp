#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {"cba_common",QUOTE(MAIN_ADDON)};
		author = "SENSEI";
		name = COMPONENT_NAME;
		//url = URL;
		VERSION_CONFIG;
	};
};

class DOUBLES(PREFIX,serverSettings) {
    #include "\userconfig\dcg\serverconfig.hpp"
};