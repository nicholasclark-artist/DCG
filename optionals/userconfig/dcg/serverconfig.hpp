/*
Author:
Nicholas Clark (SENSEI)

Description:
server config settings, this file only has an effect on the server
https://github.com/nicholasclark-artist/DCG/wiki/Settings-Framework

settings framework load order:
1. mod config
2. server config
3. mission config
4. mission parameters
5. cba settings
__________________________________________________________________*/
class dcg_main_blacklistLocations {
	typeName = "ARRAY";
	value[] = {
	};
};
class dcg_main_unitPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_soldier_UAV_F","O_Soldier_TL_F","O_Sharpshooter_F","O_Soldier_lite_F","O_Soldier_LAT_F","O_Soldier_F","O_soldier_repair_F","O_Soldier_AT_F","O_Soldier_AA_F","O_soldier_M_F","O_HeavyGunner_F","O_support_MG_F","O_Soldier_GL_F","O_soldier_exp_F","O_engineer_F","O_medic_F","O_Soldier_AR_F","O_Soldier_AAT_F","O_Soldier_AAA_F","O_support_AMG_F","O_Soldier_AAR_F","O_Soldier_A_F"}
	};
};
class dcg_main_vehPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_LSV_02_armed_F","O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F"}
	};
};
class dcg_main_airPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_Plane_CAS_02_F","O_Heli_Light_02_v2_F","O_Heli_Light_02_F","O_Heli_Attack_02_black_F","O_Heli_Attack_02_F"}
	};
};
class dcg_main_sniperPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_ghillie_sard_F","O_ghillie_lsh_F","O_ghillie_ard_F","O_sniper_F"}
	};
};
class dcg_main_officerPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_officer_F"}
	};
};
class dcg_main_artyPoolEast {
	typeName = "POOL";
	value[] = {
		{"ALL","O_T_MBT_02_arty_ghex_F","O_MBT_02_arty_F"}
	};
};
class dcg_main_unitPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_soldier_UAV_F","I_Soldier_TL_F","I_Soldier_lite_F","I_Soldier_LAT_F","I_soldier_F","I_Soldier_repair_F","I_Soldier_AT_F","I_Soldier_AA_F","I_Soldier_M_F","I_support_MG_F","I_Soldier_GL_F","I_Soldier_exp_F","I_engineer_F","I_medic_F","I_Soldier_AR_F","I_Soldier_AAT_F","I_Soldier_AAA_F","I_support_AMG_F","I_Soldier_A_F"}
	};
};
class dcg_main_vehPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_MRAP_03_hmg_F","I_APC_tracked_03_cannon_F","I_APC_Wheeled_03_cannon_F"}
	};
};
class dcg_main_airPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F","I_Heli_light_03_F"}
	};
};
class dcg_main_sniperPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_ghillie_sard_F","I_ghillie_lsh_F","I_ghillie_ard_F","I_Sniper_F"}
	};
};
class dcg_main_officerPoolInd {
	typeName = "POOL";
	value[] = {
		{"ALL","I_officer_F"}
	};
};
class dcg_main_artyPoolInd {
	typeName = "POOL";
	value[] = {
	};
};
class dcg_main_unitPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_soldier_UAV_F","B_Soldier_TL_F","B_Sharpshooter_F","B_Soldier_lite_F","B_soldier_LAT_F","B_Soldier_F","B_soldier_repair_F","B_soldier_AT_F","B_soldier_AA_F","B_soldier_M_F","B_HeavyGunner_F","B_support_MG_F","B_Soldier_GL_F","B_soldier_exp_F","B_engineer_F","B_medic_F","B_soldier_AR_F","B_soldier_AAT_F","B_soldier_AAA_F","B_support_AMG_F","B_soldier_AAR_F","B_Soldier_A_F"}
	};
};
class dcg_main_vehPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_LSV_01_armed_F","B_MRAP_01_hmg_F","B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F","B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_AA_F"}
	};
};
class dcg_main_airPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","B_Heli_Attack_01_F","B_Heli_Light_01_armed_F","B_Heli_Light_01_F"}
	};
};
class dcg_main_sniperPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_ghillie_sard_F","B_ghillie_lsh_F","B_ghillie_ard_F","B_sniper_F"}
	};
};
class dcg_main_officerPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_officer_F"}
	};
};
class dcg_main_artyPoolWest {
	typeName = "POOL";
	value[] = {
		{"ALL","B_MBT_01_mlrs_F","B_MBT_01_arty_F"}
	};
};
class dcg_main_unitPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_man_hunter_1_F","C_Man_casual_3_F_euro","C_Man_casual_1_F_euro","C_man_p_beggar_F_euro","C_man_polo_4_F_euro","C_man_polo_6_F_euro","C_man_polo_3_F_asia","C_man_polo_2_F_asia","C_man_polo_1_F_asia","C_Man_casual_5_F_asia","C_man_sport_2_F_asia","C_Man_casual_3_F_asia","C_Man_casual_2_F_asia","C_Man_casual_1_F_asia","C_man_polo_3_F_afro","C_man_polo_2_F_afro","C_man_polo_1_F_afro","C_Man_casual_6_F_afro","C_Man_casual_4_F_afro","C_man_sport_1_F_afro","C_Man_casual_3_F_afro","C_Man_casual_2_F_afro","C_Man_casual_1_F_afro"}
	};
};
class dcg_main_vehPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_Truck_02_covered_F","C_Truck_02_box_F","C_Truck_02_fuel_F","C_Van_01_box_F","C_Van_01_transport_F","C_SUV_01_F","C_Offroad_01_repair_F","C_Offroad_01_F","C_Offroad_02_unarmed_F","C_Hatchback_01_F","C_Van_01_fuel_F"}
	};
};
class dcg_main_airPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_Heli_Light_01_civil_F","C_Plane_Civil_01_F"}
	};
};
class dcg_main_vipPoolCiv {
	typeName = "POOL";
	value[] = {
		{"ALL","C_Nikos","C_Nikos_aged"}
	};
};
class dcg_radio_commNet01 {
	typeName = "ARRAY";
	value[] = {
		"plt_pl",
		"a_sl",
		"b_sl"
	};
};
class dcg_radio_commNet02 {
	typeName = "ARRAY";
	value[] = {
		"plt_fo",
		"r1_pilot",
		"r1_copilot",
		"r2_pilot",
		"r2_copilot",
		"rh1_co"
	};
};
class dcg_radio_commNet03 {
	typeName = "ARRAY";
	value[] = {
		"plt_pl",
		"plt_sgt",
		"plt_med",
		"plt_fo"
	};
};
class dcg_radio_commNet04 {
	typeName = "ARRAY";
	value[] = {
		"a_sl",
		"a_med",
		"a1_ftl",
		"a1_ar",
		"a1_gr",
		"a1_r",
		"a2_ftl",
		"a2_ar",
		"a2_gr",
		"a2_r"
	};
};
class dcg_radio_commNet05 {
	typeName = "ARRAY";
	value[] = {
		"b_sl",
		"b_med",
		"b1_ftl",
		"b1_ar",
		"b1_gr",
		"b1_r",
		"b2_ftl",
		"b2_ar",
		"b2_gr",
		"b2_r"
	};
};
class dcg_radio_commNet06 {
	typeName = "ARRAY";
	value[] = {
		"rh1_co",
		"rh1_driver",
		"rh1_gunner"
	};
};
