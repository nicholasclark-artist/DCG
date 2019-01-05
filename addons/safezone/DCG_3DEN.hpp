/*
    https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes
*/

#define SAFEZONE_ITEM ADDON
#define SAFEZONE_TEXT "DCG - Safezone"
#define SAFEZONE_CREATE GVAR(create)
#define SAFEZONE_CREATE_TEXT "Set as Safezone"
#define SAFEZONE_CREATE_TIP "Enable to set as safezone."

class Cfg3DEN {
    class Marker {
        class AttributeCategories {
            class SAFEZONE_ITEM {
                displayName = SAFEZONE_TEXT;
                collapsed = 1;
                class Attributes {
                    class SAFEZONE_CREATE {
                        displayName = SAFEZONE_CREATE_TEXT;
                        tooltip = SAFEZONE_CREATE_TIP;
                        property = QUOTE(SAFEZONE_CREATE);
                        control = "Checkbox";
                        expression = QUOTE([_this] call FUNC(init));
                        defaultValue = "false";
                        unique = 0;
                        // validate = "number";
                        // condition = "objectSimulated";
                        // typeName = "NUMBER";
                    };
                };
            };
        };
    };
};
