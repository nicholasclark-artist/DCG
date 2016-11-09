/*
Author:
Nicholas Clark (SENSEI)

Description:
server config settings, this file only has an effect on the server

settings framework load order:
1. mod config
2. server config
3. mission config
4. mission parameters
__________________________________________________________________*/
class dcg_main_init {
	typeName = "ARRAY";
	value[] = {
		"ALL"
	};
};
class dcg_main_debug {
	typeName = "SCALAR";
	value = 0;
};
class dcg_main_loadData {
	typeName = "BOOL";
	value = 1;
};
class dcg_main_autoSave {
	typeName = "BOOL";
	value = 0;
};
class dcg_main_baseName {
	typeName = "STRING";
	value = "MOB Dodge";
};
class dcg_main_baseRadius {
	typeName = "SCALAR";
	value = (worldSize*0.055);
};
class dcg_main_baseSafezone {
	typeName = "BOOL";
	value = 1;
};
class dcg_main_blacklistLocations {
	typeName = "ARRAY";
	value[] = {
	};
};
class dcg_main_unitPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_soldier_AR_F","O_medic_F","O_soldier_exp_F","O_soldier_GL_F","O_soldier_AT_F","O_soldier_repair_F","O_soldier_AAR_F","O_soldier_M_F","O_soldier_F","O_support_AMG_F","O_support_MG_F","O_engineer_F","O_Soldier_AA_F"}
	};
};
class dcg_main_vehPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_APC_Tracked_02_AA_F","O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_Quadbike_01_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_Truck_02_covered_F","O_Truck_03_transport_F"}
	};
};
class dcg_main_airPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_Heli_Light_02_F","O_Heli_Attack_02_F","O_Plane_CAS_02_F"}
	};
};
class dcg_main_sniperPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_sniper_F"}
	};
};
class dcg_main_officerPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_officer_F"}
	};
};
class dcg_main_unitPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_soldier_AR_F","I_medic_F","I_soldier_exp_F","I_soldier_GL_F","I_soldier_AT_F","I_soldier_repair_F","I_soldier_AAR_F","I_soldier_M_F","I_soldier_F","I_support_AMG_F","I_support_MG_F","I_engineer_F","I_Soldier_AA_F"}
	};
};
class dcg_main_vehPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_MRAP_03_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_Quadbike_01_F","I_APC_tracked_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_Truck_02_covered_F","I_Truck_02_transport_F"}
	};
};
class dcg_main_airPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_Heli_light_03_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"}
	};
};
class dcg_main_sniperPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_sniper_F"}
	};
};
class dcg_main_officerPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_officer_F"}
	};
};
class dcg_main_unitPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_Soldier_SL_F","B_medic_F","B_soldier_AR_F","B_soldier_M_F","B_Soldier_AA_F","B_soldier_AT_F","B_soldier_F"}
	};
};
class dcg_main_vehPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_mrap_01_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F"}
	};
};
class dcg_main_airPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_Heli_Transport_03_F","B_Heli_Transport_01_F","B_Heli_Light_01_F","B_Plane_CAS_01_F","B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"}
	};
};
class dcg_main_sniperPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_sniper_F"}
	};
};
class dcg_main_officerPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_officer_F"}
	};
};
class dcg_main_unitPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F","C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F","C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F","C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_man_w_worker_F"}
	};
};
class dcg_main_vehPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_Offroad_01_F","C_SUV_01_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_01_transport_F"}
	};
};
class dcg_main_airPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_Heli_Light_01_civil_F"}
	};
};
class dcg_occupy_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_occupy_cooldown {
	typeName = "SCALAR";
	value = 300;
};
class dcg_occupy_locationCount {
	typeName = "SCALAR";
	value = 1;
};
class dcg_occupy_infCountCapital {
	typeName = "SCALAR";
	value = 30;
};
class dcg_occupy_vehCountCapital {
	typeName = "SCALAR";
	value = 2;
};
class dcg_occupy_airCountCapital {
	typeName = "SCALAR";
	value = 1;
};
class dcg_occupy_infCountCity {
	typeName = "SCALAR";
	value = 15;
};
class dcg_occupy_vehCountCity {
	typeName = "SCALAR";
	value = 1;
};
class dcg_occupy_airCountCity {
	typeName = "SCALAR";
	value = 1;
};
class dcg_occupy_infCountVillage {
	typeName = "SCALAR";
	value = 10;
};
class dcg_occupy_vehCountVillage {
	typeName = "SCALAR";
	value = 0;
};
class dcg_occupy_airCountVillage {
	typeName = "SCALAR";
	value = 0;
};
class dcg_patrol_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_patrol_cooldown {
	typeName = "SCALAR";
	value = 600;
};
class dcg_patrol_groupsMaxCount {
	typeName = "SCALAR";
	value = 10;
};
class dcg_patrol_vehChance {
	typeName = "SCALAR";
	value = 0.15;
};
class dcg_radio_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_radio_tfar_command {
	typeName = "STRING";
	value = "tf_anprc152";
};
class dcg_radio_tfar_support {
	typeName = "STRING";
	value = "tf_rt1523g_big";
};
class dcg_radio_tfar_squad {
	typeName = "STRING";
	value = "tf_rf7800str";
};
class dcg_radio_acre_command {
	typeName = "STRING";
	value = "ACRE_PRC152";
};
class dcg_radio_acre_support {
	typeName = "STRING";
	value = "ACRE_PRC117F";
};
class dcg_radio_acre_squad {
	typeName = "STRING";
	value = "ACRE_PRC343";
};
class dcg_radio_commandNet {
	typeName = "ARRAY";
	value[] = {
		"plt_co",
		"a_sl",
		"b_sl"
	};
};
class dcg_radio_supportNet {
	typeName = "ARRAY";
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
	value[] = {
		{"plt_co","plt_sgt","plt_med","plt_eng"},
		{"a_sl","a_med","a1_ftl","a1_ar","a1_aar","a1_at","a1_ab","a1_eng","a2_ftl","a2_ar","a2_aar","a2_at","a2_ab","a2_eng"},
		{"b_sl","b_med","b1_ftl","b1_ar","b1_aar","b1_at","b1_ab","b1_eng","b2_ftl","b2_ar","b2_aar","b2_at","b2_ab","b2_eng"},
		{"rh1_co","rh1_driver","rh1_gunner"},
		{"r_1","r_2","r_3","r_4"}
	};
};
class dcg_respawn_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_task_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_task_cooldown {
	typeName = "SCALAR";
	value = 480;
};
class dcg_transport_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_transport_maxCount {
	typeName = "SCALAR";
	value = 3;
};
class dcg_transport_cooldown {
	typeName = "SCALAR";
	value = 300;
};
class dcg_weather_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_weather_season {
	typeName = "SCALAR";
	value = -1;
};
class dcg_weather_time {
	typeName = "SCALAR";
	value = -1;
};
class dcg_weather_mapData {
	typeName = "WORLD";
	value[] = {
		{"ALTIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
		{"STRATIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
		{"TAKISTAN",0.54,0.6,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
		{"KUNDUZ",0.54,0.6,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
		{"MOUNTAINS_ACR",0.54,0.6,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
		{"CHERNARUS",0.98,0.94,0.85,0.76,0.7,0.74,0.7,0.64,0.73,0.84,0.93,0.97},
		{"CHERNARUS_SUMMER",0.73,0.72,0.7,0.72,0.74,0.7,0.68,0.65,0.64,0.69,0.7,0.75},
		{"TANOA",0.8,0.78,0.7,0.63,0.57,0.55,0.48,0.49,0.57,0.64,0.71,0.79}
	};
};
class dcg_approval_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_approval_multiplier {
	typeName = "SCALAR";
	value = 1;
};
class dcg_approval_hostileCooldown {
	typeName = "SCALAR";
	value = 900;
};
class dcg_cache_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_cache_dist {
	typeName = "SCALAR";
	value = 2000;
};
class dcg_civilian_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_civilian_spawnDist {
	typeName = "SCALAR";
	value = 400;
};
class dcg_civilian_countCapital {
	typeName = "SCALAR";
	value = 18;
};
class dcg_civilian_countCity {
	typeName = "SCALAR";
	value = 10;
};
class dcg_civilian_countVillage {
	typeName = "SCALAR";
	value = 5;
};
class dcg_civilian_vehMaxCount {
	typeName = "SCALAR";
	value = 8;
};
class dcg_civilian_vehCooldown {
	typeName = "SCALAR";
	value = 300;
};
class dcg_fob_enable {
	typeName = "SCALAR";
	value = 1;
};
class dcg_fob_name {
	typeName = "STRING";
	value = "FOB Pirelli";
};
class dcg_fob_range {
	typeName = "SCALAR";
	value = 100;
};
class dcg_fob_whitelist {
	typeName = "ARRAY";
	value[] = {
		"ALL"
	};
};
class dcg_fob_placeCoef {
	typeName = "SCALAR";
	value = -0.025;
};
class dcg_fob_deleteCoef {
	typeName = "SCALAR";
	value = 0.025;
};
class dcg_ied_enable {
	typeName = "SCALAR";
	value = 1;
};
