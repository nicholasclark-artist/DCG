/*
    Types (SCALAR, BOOL, SIDE)
*/

class dcg_main_debug {
   title = "Debug Mode";
   values[] = {0,1};
   texts[] = {"Off", "On"};
   default = 0;
   dcg_setting = 1;
   typeName = "";
};
class dcg_main_loadData {
   title = "Load Mission Data";
   values[] = {0,1};
   texts[] = {"Off", "On"};
   default = 1;
   dcg_setting = 1;
   typeName = "BOOL";
};
class dcg_main_enemySide {
   title = "Enemy Side";
   values[] = {0,2};
   texts[] = {"East", "Independent"};
   default = 0;
   dcg_setting = 1;
   typeName = "SIDE";
};
class dcg_mission_disableCam {
   title = "Disable Third Person Camera";
   values[] = {0,1};
   texts[] = {"Off", "On"};
   default = 0;
   dcg_setting = 1;
   typeName = "BOOL";
};
class dcg_weather_season {
   title = "Season";
   values[] = {-1,0,1,2,3};
   texts[] = {"Random","Summer","Fall","Winter","Spring"};
   default = -1;
   dcg_setting = 1;
   typeName = "";
};
class dcg_weather_time {
   title = "Time of Day";
   values[] = {-1,0,1,2,3};
   texts[] = {"Random","Morning","Midday","Evening","Night"};
   default = -1;
   dcg_setting = 1;
   typeName = "";
};