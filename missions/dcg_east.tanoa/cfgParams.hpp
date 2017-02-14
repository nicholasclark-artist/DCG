/*
    Types (SCALAR, BOOL, SIDE)
*/

/*class dcg_main_testSetting {
   title = "";
   values[] = {0,1};
   texts[] = {"Off", "On"};
   default = 0;
   dcg_setting = 1;
   typeName = "BOOL";
};*/

class ace_repair_engineerSetting_repair {
    title = "ACE3 - Players Allowed to Perform Repair Actions";
    values[] = {0,1,2};
    texts[] =  {"Anyone", "Engineers", "Repair Specialists"};
    default = 0;
    ACE_setting = 1;
    dcg_setting = 0;
    typeName = "SCALAR";
};

class ace_repair_engineerSetting_wheel {
    title = "ACE3 - Players Allowed to Remove/Replace Wheels";
    values[] = {0,1,2};
    texts[] =  {"Anyone", "Engineers", "Repair Specialists"};
    default = 0;
    ACE_setting = 1;
    dcg_setting = 0;
    typeName = "SCALAR";
};

class ace_explosives_requireSpecialist {
    title = "ACE3 - Require Specialist to Defuse Explosives";
    values[] = {1,0};
    texts[] =  {"Yes", "No"};
    default = 0;
    ACE_setting = 1;
    dcg_setting = 0;
    typeName = "BOOL";
};
