/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 1;
    };
    class GVAR(cooldown) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 480;
    };
    class GVAR(primaryTasks) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {
            QFUNC(prim_vip),
            QFUNC(prim_cache),
            QFUNC(prim_officer),
            QFUNC(prim_arty),
            QFUNC(prim_defend)
        };
    };
    class GVAR(secondaryTasks) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {
            QFUNC(sec_deliver),
            QFUNC(sec_repair),
            QFUNC(sec_officer),
            QFUNC(sec_intel01),
            QFUNC(sec_intel02)
        };
    };
};