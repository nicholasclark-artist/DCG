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
    class GVAR(addons) {
        typeName = "ARRAY";
        typeDetail = "";
        value[] = {"A3_Characters_F_BLUFOR","A3_Soft_F_MRAP_01","A3_Soft_F_HEMTT","A3_Structures_F_Mil_Cargo","A3_Structures_F_Mil_Fortification","A3_Structures_F_Mil_Helipads","A3_Structures_F_Mil_Shelters","A3_Structures_F_Civ_Lamps","A3_Structures_F_Mil_BagBunker","A3_Structures_F_Mil_BagFence","A3_Structures_F_Civ_Camping","ace_medical"};
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