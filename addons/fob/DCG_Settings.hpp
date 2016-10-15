/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 1;
    };
    class GVAR(name) {
        typeName = "STRING";
        typeDetail = "";
        value = "FOB Pirelli";
    };
    class GVAR(range) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 100;
    };
    class GVAR(whitelist) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {"ALL"};
    };
    class GVAR(placingMultiplier) {
        typeName = "SCALAR";
        typeDetail = "";
        value = -0.025;
    };
    class GVAR(deletingMultiplier) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 0.025;
    };
};