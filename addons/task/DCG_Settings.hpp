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
    class GVAR(primaryBlacklist) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {
        };
    };
    class GVAR(secondaryBlacklist) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {
        };
    };
};