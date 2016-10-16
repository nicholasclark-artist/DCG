/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        value = 1;
    };
    class GVAR(maxCount) {
        typeName = "SCALAR";
        value = 3;
    };
    class GVAR(cooldown) {
        typeName = "SCALAR";
        value = 300;
    };
};