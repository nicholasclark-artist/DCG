/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        value = 1;
    };
    class GVAR(cooldown) {
        typeName = "SCALAR";
        value = 900;
    };
    class GVAR(groupsMaxCount) {
        typeName = "SCALAR";
        value = 8;
    };
    class GVAR(vehChance) {
        typeName = "SCALAR";
        value = 0.25;
    };
};
