/*
    Types (SCALAR, BOOL, STRING, ARRAY)
*/

class DOUBLES(PREFIX,settings) {
    class GVAR(enable) {
        typeName = "SCALAR";
        typeDetail = "";
        value = 1;
    };
    class GVAR(season) {
        typeName = "SCALAR";
        typeDetail = "";
        value = -1;
    };
    class GVAR(time) {
        typeName = "SCALAR";
        typeDetail = "";
        value = -1;
    };
    class GVAR(mapData) { // weatherspark.com
        typeName = "ARRAY";
        typeDetail = "WORLD";
        value[] = {
            {"ALTIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
            {"STRATIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
            {"TAKISTAN",0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
            {"KUNDUZ",0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
            {"MOUNTAINS_ACR",0.54,0.60,0.55,0.46,0.32,0.19,0.15,0.15,0.12,0.15,0.25,0.41},
            {"CHERNARUS",0.98,0.96,0.93,0.90,0.86,0.84,0.84,0.86,0.88,0.94,0.96,0.98},
            {"CHERNARUS_SUMMER",0.98,0.96,0.93,0.90,0.86,0.84,0.84,0.86,0.88,0.94,0.96,0.98},
            {"TANOA",0.90,0.85,0.84,0.82,0.83,0.79,0.75,0.72,0.80,0.84,0.86,0.90}
        };
    };
};