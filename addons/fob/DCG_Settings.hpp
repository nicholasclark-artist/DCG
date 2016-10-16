/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        value = 1;
    };
    class GVAR(name) {
        typeName = "STRING";
        value = "FOB Pirelli";
    };
    class GVAR(range) {
        typeName = "SCALAR";
        value = 100;
    };
    class GVAR(whitelist) {
        typeName = "ARRAY";
        value[] = {"ALL"};
    };
    class GVAR(placingMultiplier) {
        typeName = "SCALAR";
        value = -0.025;
    };
    class GVAR(deletingMultiplier) {
        typeName = "SCALAR";
        value = 0.025;
    };
};