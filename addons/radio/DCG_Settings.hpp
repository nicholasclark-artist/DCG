/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        value = 1;
    };
    class GVAR(commNet01) {
        typeName = "ARRAY";
        value[] = {"plt_co","a_sl","b_sl"};
    };
    class GVAR(commNet01_ACRE) {
        typeName = "STRING";
        value = "ACRE_PRC152";
    };
    class GVAR(commNet01_TFAR) {
        typeName = "STRING";
        value = "tf_anprc152";
    };
    class GVAR(commNet02) {
        typeName = "ARRAY";
        value[] = {"plt_sgt","r_1","r_2","r_3","r_4","rh1_co"};
    };
    class GVAR(commNet02_ACRE) {
        typeName = "STRING";
        value = "ACRE_PRC117F";
    };
    class GVAR(commNet02_TFAR) {
        typeName = "STRING";
        value = "tf_rt1523g_big";
    };
    class GVAR(commNet03) {
        typeName = "ARRAY";
        value[] = {"plt_co","plt_sgt","plt_med","plt_eng"};
    };
    class GVAR(commNet03_ACRE) {
        typeName = "STRING";
        value = "ACRE_PRC343";
    };
    class GVAR(commNet03_TFAR) {
        typeName = "STRING";
        value = "tf_rf7800str";
    };
    class GVAR(commNet04) {
        typeName = "ARRAY";
        value[] = {"a_sl","a_med","a1_ftl","a1_ar","a1_aar","a1_at","a1_ab","a1_eng","a2_ftl","a2_ar","a2_aar","a2_at","a2_ab","a2_eng"};
    };
    class GVAR(commNet04_ACRE) {
        typeName = "STRING";
        value = "ACRE_PRC343";
    };
    class GVAR(commNet04_TFAR) {
        typeName = "STRING";
        value = "tf_rf7800str";
    };
    class GVAR(commNet05) {
        typeName = "ARRAY";
        value[] = {"b_sl","b_med","b1_ftl","b1_ar","b1_aar","b1_at","b1_ab","b1_eng","b2_ftl","b2_ar","b2_aar","b2_at","b2_ab","b2_eng"};
    };
    class GVAR(commNet05_ACRE) {
        typeName = "STRING";
        value = "ACRE_PRC343";
    };
    class GVAR(commNet05_TFAR) {
        typeName = "STRING";
        value = "tf_rf7800str";
    };
    class GVAR(commNet06) {
        typeName = "ARRAY";
        value[] = {"rh1_co","rh1_driver","rh1_gunner"};
    };
    class GVAR(commNet06_ACRE) {
        typeName = "STRING";
        value = "ACRE_PRC343";
    };
    class GVAR(commNet06_TFAR) {
        typeName = "STRING";
        value = "tf_rf7800str";
    };
};
