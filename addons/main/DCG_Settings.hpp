/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(init) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {"ALL"};
    };
    class GVAR(debug) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 0;
    };
    class GVAR(loadData) {
        typeName = "BOOL";
        typeDetail = "";
        value = 1;
    };
    class GVAR(baseName) {
        typeName = "STRING";
        typeDetail = "";
        value = "MOB Dodge";
    };
    class GVAR(baseRadius) {
        typeName = "SCALAR";
        typeDetail = "";
        value = (worldSize*0.055);
    };
    class GVAR(baseSafezone) {
        typeName = "BOOL";
        typeDetail = "";
        value = 1;
    };
    class GVAR(blacklistLocations) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {};
    };
    class GVAR(simpleWorlds) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {"Chernarus","Chernarus_Summer"};
    };
    class GVAR(unitPoolEast) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","O_soldier_AR_F","O_medic_F","O_soldier_exp_F","O_soldier_GL_F","O_soldier_AT_F","O_soldier_repair_F","O_soldier_AAR_F","O_soldier_M_F","O_soldier_F","O_support_AMG_F","O_support_MG_F","O_engineer_F","O_Soldier_AA_F"}
        };
    };
    class GVAR(vehPoolEast) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","O_APC_Tracked_02_AA_F","O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_Quadbike_01_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_Truck_02_covered_F","O_Truck_03_transport_F"}
        };
    };
    class GVAR(airPoolEast) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","O_Heli_Light_02_F","O_Heli_Attack_02_F","O_Plane_CAS_02_F"}
        };
    };
    class GVAR(sniperPoolEast) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","O_sniper_F"}
        };
    };
    class GVAR(officerPoolEast) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","O_officer_F"}
        };
    };
    class GVAR(unitPoolInd) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","I_soldier_AR_F","I_medic_F","I_soldier_exp_F","I_soldier_GL_F","I_soldier_AT_F","I_soldier_repair_F","I_soldier_AAR_F","I_soldier_M_F","I_soldier_F","I_support_AMG_F","I_support_MG_F","I_engineer_F","I_Soldier_AA_F"}
        };
    };
    class GVAR(vehPoolInd) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Quadbike_01_F","I_APC_tracked_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_Truck_02_covered_F","I_Truck_02_transport_F"}
        };
    };
    class GVAR(airPoolInd) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","I_Heli_light_03_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"}
        };
    };
    class GVAR(sniperPoolInd) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","I_sniper_F"}
        };
    };
    class GVAR(officerPoolInd) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","I_officer_F"}
        };
    };
    class GVAR(unitPoolWest) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","B_Soldier_SL_F","B_medic_F","B_soldier_AR_F","B_soldier_M_F","B_Soldier_AA_F","B_soldier_AT_F","B_soldier_F"}
        };
    };
    class GVAR(vehPoolWest) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","B_mrap_01_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F"}
        };
    };
    class GVAR(airPoolWest) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","B_Heli_Transport_03_F","B_Heli_Transport_01_F","B_Heli_Light_01_F","B_Plane_CAS_01_F","B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"}
        };
    };
    class GVAR(sniperPoolWest) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","B_sniper_F"}
        };
    };
    class GVAR(officerPoolWest) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","B_officer_F"}
        };
    };
    class GVAR(unitPoolCiv) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_man_w_worker_F"}
        };
    };
    class GVAR(vehPoolCiv) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F"}
        };
    };
    class GVAR(airPoolCiv) {
        typeName = "ARRAY";
        typeDetail = "POOL";
        value[] = {
            {"ALL","C_Heli_Light_01_civil_F"}
        };
    };
};