/*
Author:
Nicholas Clark (SENSEI)

Description:
handles server side DCG settings, this file only has an effect on the server
__________________________________________________________________*/
class dcg_main_debug {
	typeName = "SCALAR";
	typeDetail = "";
	value = 0;
};
class dcg_main_loadData {
	typeName = "BOOL";
	typeDetail = "";
	value = 1;
};
class dcg_main_baseName {
	typeName = "STRING";
	typeDetail = "";
	value = "MOB Dodge";
};
class dcg_main_baseRadius {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1800;
};
class dcg_main_baseSafezone {
	typeName = "BOOL";
	typeDetail = "";
	value = 1;
};
class dcg_main_blacklistLocations {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
	};
};
class dcg_main_simpleWorlds {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		"Chernarus",
		"Chernarus_Summer"
	};
};
class dcg_main_unitPoolEast {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","O_soldier_AR_F","O_medic_F","O_soldier_exp_F","O_soldier_GL_F","O_soldier_AT_F","O_soldier_repair_F","O_soldier_AAR_F","O_soldier_M_F","O_soldier_F","O_support_AMG_F","O_support_MG_F","O_engineer_F","O_Soldier_AA_F"}
	};
};
class dcg_main_vehPoolEast {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","O_APC_Tracked_02_AA_F","O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_Quadbike_01_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_Truck_02_covered_F","O_Truck_03_transport_F"}
	};
};
class dcg_main_airPoolEast {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","O_Heli_Light_02_F","O_Heli_Attack_02_F","O_Plane_CAS_02_F"}
	};
};
class dcg_main_sniperPoolEast {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","O_sniper_F"}
	};
};
class dcg_main_officerPoolEast {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","O_officer_F"}
	};
};
class dcg_main_unitPoolInd {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","I_soldier_AR_F","I_medic_F","I_soldier_exp_F","I_soldier_GL_F","I_soldier_AT_F","I_soldier_repair_F","I_soldier_AAR_F","I_soldier_M_F","I_soldier_F","I_support_AMG_F","I_support_MG_F","I_engineer_F","I_Soldier_AA_F"}
	};
};
class dcg_main_vehPoolInd {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Quadbike_01_F","I_APC_tracked_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_Truck_02_covered_F","I_Truck_02_transport_F"}
	};
};
class dcg_main_airPoolInd {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","I_Heli_light_03_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"}
	};
};
class dcg_main_sniperPoolInd {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","I_sniper_F"}
	};
};
class dcg_main_officerPoolInd {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","I_officer_F"}
	};
};
class dcg_main_unitPoolWest {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","B_Soldier_SL_F","B_medic_F","B_soldier_AR_F","B_soldier_M_F","B_Soldier_AA_F","B_soldier_AT_F","B_soldier_F"}
	};
};
class dcg_main_vehPoolWest {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","B_mrap_01_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F"}
	};
};
class dcg_main_airPoolWest {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","B_Heli_Transport_03_F","B_Heli_Transport_01_F","B_Heli_Light_01_F","B_Plane_CAS_01_F","B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"}
	};
};
class dcg_main_sniperPoolWest {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","B_sniper_F"}
	};
};
class dcg_main_officerPoolWest {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","B_officer_F"}
	};
};
class dcg_main_unitPoolCiv {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_man_w_worker_F"}
	};
};
class dcg_main_vehPoolCiv {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F"}
	};
};
class dcg_main_airPoolCiv {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL","C_Heli_Light_01_civil_F"}
	};
};
class dcg_occupy_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_occupy_cooldown {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1200;
};
class dcg_occupy_locationCount {
	typeName = "SCALAR";
	typeDetail = "";
	value = 2;
};
class dcg_occupy_infCountCapital {
	typeName = "SCALAR";
	typeDetail = "";
	value = 30;
};
class dcg_occupy_vehCountCapital {
	typeName = "SCALAR";
	typeDetail = "";
	value = 2;
};
class dcg_occupy_airCountCapital {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_occupy_infCountCity {
	typeName = "SCALAR";
	typeDetail = "";
	value = 15;
};
class dcg_occupy_vehCountCity {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_occupy_airCountCity {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_occupy_infCountVillage {
	typeName = "SCALAR";
	typeDetail = "";
	value = 8;
};
class dcg_occupy_vehCountVillage {
	typeName = "SCALAR";
	typeDetail = "";
	value = 0;
};
class dcg_occupy_airCountVillage {
	typeName = "SCALAR";
	typeDetail = "";
	value = 0;
};
class dcg_patrol_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_patrol_cooldown {
	typeName = "SCALAR";
	typeDetail = "";
	value = 420;
};
class dcg_patrol_groupsMaxCount {
	typeName = "SCALAR";
	typeDetail = "";
	value = 20;
};
class dcg_patrol_vehChance {
	typeName = "SCALAR";
	typeDetail = "";
	value = 0.15;
};
class dcg_radio_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_radio_tfar_command {
	typeName = "STRING";
	typeDetail = "";
	value = "tf_anprc152";
};
class dcg_radio_tfar_support {
	typeName = "STRING";
	typeDetail = "";
	value = "tf_rt1523g_big";
};
class dcg_radio_tfar_squad {
	typeName = "STRING";
	typeDetail = "";
	value = "tf_rf7800str";
};
class dcg_radio_acre_command {
	typeName = "STRING";
	typeDetail = "";
	value = "ACRE_PRC152";
};
class dcg_radio_acre_support {
	typeName = "STRING";
	typeDetail = "";
	value = "ACRE_PRC117F";
};
class dcg_radio_acre_squad {
	typeName = "STRING";
	typeDetail = "";
	value = "ACRE_PRC343";
};
class dcg_radio_commandNet {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		"plt_co",
		"a_sl",
		"b_sl"
	};
};
class dcg_radio_supportNet {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		"plt_sgt",
		"r_1",
		"r_2",
		"r_3",
		"r_4",
		"rh1_co"
	};
};
class dcg_radio_squadNet {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		{"plt_co","plt_sgt","plt_med","plt_eng"},
		{"a_sl","a_med","a1_ftl","a1_ar","a1_aar","a1_at","a1_ab","a1_eng","a2_ftl","a2_ar","a2_aar","a2_at","a2_ab","a2_eng"},
		{"b_sl","b_med","b1_ftl","b1_ar","b1_aar","b1_at","b1_ab","b1_eng","b2_ftl","b2_ar","b2_aar","b2_at","b2_ab","b2_eng"},
		{"rh1_co","rh1_driver","rh1_gunner"},
		{"r_1","r_2","r_3","r_4"}
	};
};
class dcg_task_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_task_cooldown {
	typeName = "SCALAR";
	typeDetail = "";
	value = 900;
};
class dcg_task_primaryTasks {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		"dcg_task_fnc_pVip",
		"dcg_task_fnc_pCache",
		"dcg_task_fnc_pOfficer",
		"dcg_task_fnc_pDefend"
	};
};
class dcg_task_secondaryTasks {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		"dcg_task_fnc_sDeliver",
		"dcg_task_fnc_sRepair"
	};
};
class dcg_transport_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_transport_maxCount {
	typeName = "SCALAR";
	typeDetail = "";
	value = 3;
};
class dcg_transport_cooldown {
	typeName = "SCALAR";
	typeDetail = "";
	value = 300;
};
class dcg_weather_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_weather_season {
	typeName = "SCALAR";
	typeDetail = "";
	value = -1;
};
class dcg_weather_time {
	typeName = "SCALAR";
	typeDetail = "";
	value = -1;
};
class dcg_weather_mapData {
	typeName = "ARRAY";
	typeDetail = "POOL";
	value[] = {
		{"ALL",0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},
		{"ALTIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
		{"STRATIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
		{"TAKISTAN",0.54,0.6,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
		{"KUNDUZ",0.54,0.6,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
		{"MOUNTAINS_ACR",0.54,0.6,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
		{"CHERNARUS",0.98,0.96,0.93,0.9,0.86,0.84,0.84,0.86,0.88,0.94,0.96,0.98},
		{"CHERNARUS_SUMMER",0.98,0.96,0.93,0.9,0.86,0.84,0.84,0.86,0.88,0.94,0.96,0.98}
	};
};
class dcg_cache_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_cache_dist {
	typeName = "SCALAR";
	typeDetail = "";
	value = 2000;
};
class dcg_civilian_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_civilian_spawnDist {
	typeName = "SCALAR";
	typeDetail = "";
	value = 500;
};
class dcg_civilian_countCapital {
	typeName = "SCALAR";
	typeDetail = "";
	value = 18;
};
class dcg_civilian_countCity {
	typeName = "SCALAR";
	typeDetail = "";
	value = 10;
};
class dcg_civilian_countVillage {
	typeName = "SCALAR";
	typeDetail = "";
	value = 5;
};
class dcg_civilian_hostileChance {
	typeName = "SCALAR";
	typeDetail = "";
	value = 0.1;
};
class dcg_civilian_vehMaxCount {
	typeName = "SCALAR";
	typeDetail = "";
	value = 8;
};
class dcg_civilian_vehCooldown {
	typeName = "SCALAR";
	typeDetail = "";
	value = 600;
};
class dcg_fob_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
class dcg_fob_name {
	typeName = "STRING";
	typeDetail = "";
	value = "FOB Pirelli";
};
class dcg_fob_range {
	typeName = "SCALAR";
	typeDetail = "";
	value = 100;
};
class dcg_fob_rangeRecon {
	typeName = "SCALAR";
	typeDetail = "";
	value = 2500;
};
class dcg_fob_cooldownRecon {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1800;
};
class dcg_fob_flagTexturePath {
	typeName = "STRING";
	typeDetail = "";
	value = "\A3\Data_F\Flags\flag_nato_co.paa";
};
class dcg_fob_addons {
	typeName = "ARRAY";
	typeDetail = "";
	value[] = {
		"A3_Characters_F_BLUFOR",
		"A3_Soft_F_MRAP_01",
		"A3_Soft_F_HEMTT",
		"A3_Structures_F_Mil_Cargo",
		"A3_Structures_F_Mil_Fortification",
		"A3_Structures_F_Mil_Helipads",
		"A3_Structures_F_Mil_Shelters",
		"A3_Structures_F_Civ_Lamps",
		"A3_Structures_F_Mil_BagBunker",
		"A3_Structures_F_Mil_BagFence",
		"A3_Structures_F_Civ_Camping",
		"ace_medical"
	};
};
class dcg_fob_placingMultiplier {
	typeName = "SCALAR";
	typeDetail = "";
	value = -0.025;
};
class dcg_fob_deletingMultiplier {
	typeName = "SCALAR";
	typeDetail = "";
	value = 0.025;
};
class dcg_ied_enable {
	typeName = "SCALAR";
	typeDetail = "";
	value = 1;
};
