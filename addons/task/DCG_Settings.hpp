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
        value = 900;
    };
    class GVAR(primaryTasks) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {
            QUOTE(FUNC(pVip)),
            QUOTE(FUNC(pCache)),
            QUOTE(FUNC(pOfficer))
        };
    };
    class GVAR(secondaryTasks) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {

        };
    };
};