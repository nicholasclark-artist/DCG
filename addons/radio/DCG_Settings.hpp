/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(commNet01) {
        typeName = "ARRAY";
        value[] = {"plt_pl","a_sl","b_sl"};
    };
    class GVAR(commNet02) {
        typeName = "ARRAY";
        value[] = {"plt_fo","r1_pilot","r1_copilot","r2_pilot","r2_copilot","rh1_co"};
    };
    class GVAR(commNet03) {
        typeName = "ARRAY";
        value[] = {"plt_pl","plt_sgt","plt_med","plt_fo"};
    };
    class GVAR(commNet04) {
        typeName = "ARRAY";
        value[] = {"a_sl","a_med","a1_ftl","a1_ar","a1_gr","a1_r","a2_ftl","a2_ar","a2_gr","a2_r"};
    };
    class GVAR(commNet05) {
        typeName = "ARRAY";
        value[] = {"b_sl","b_med","b1_ftl","b1_ar","b1_gr","b1_r","b2_ftl","b2_ar","b2_gr","b2_r"};
    };
    class GVAR(commNet06) {
        typeName = "ARRAY";
        value[] = {"rh1_co","rh1_driver","rh1_gunner"};
    };
};
