/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 1;
    };
    class GVAR(interval) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 600;
    };
    class GVAR(groupsDynamicMaxCount) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 10;
    };
    class GVAR(armoredChance) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 0.1;
    };
};