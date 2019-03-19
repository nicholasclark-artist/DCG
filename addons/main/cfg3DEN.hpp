/*
    https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes
*/
#include "\a3\3DEN\UI\macros.inc"

#define SAVE_ITEM GVAR(save)
#define SAVE_TEXT "DCG - Save"
#define SAVE_ENTITY GVAR(saveEntity)
#define SAVE_ENTITY_TEXT "Save Entity"
#define SAVE_ENTITY_TIP "Add entity to save system"

#define SAFEZONE_ITEM GVAR(safezone)
#define SAFEZONE_TEXT "DCG - Safezone"
#define SAFEZONE_CREATE GVAR(safezoneCreate)
#define SAFEZONE_CREATE_TEXT "Set as Safezone"
#define SAFEZONE_CREATE_TIP "Enable to set as safezone"

#define COMP_ITEM GVAR(comp)
#define COMP_TEXT "DCG - Composition"
#define COMP_VECTORUP GVAR(vectorUp)
#define COMP_VECTORUP_TEXT "Ignore Terrain Vector"
#define COMP_VECTORUP_TIP ""

class Cfg3DEN {
    class Object {
        class AttributeCategories {
            class COMP_ITEM {
                displayName = COMP_TEXT;
                collapsed = 1;
                class Attributes {
                    class COMP_VECTORUP {
                        displayName = COMP_VECTORUP_TEXT;
                        tooltip = COMP_VECTORUP_TIP;
                        property = QUOTE(COMP_VECTORUP);
                        control = "Checkbox";
                        expression = "";
                        defaultValue = "false";
                        unique = 0;
                        // validate = "number";
                        condition = "1 - (objectAgent + logicModule + objectBrain)";
                        // typeName = "NUMBER";
                    };
                };
            };
            class SAVE_ITEM {
                displayName = SAVE_TEXT;
                collapsed = 1;
                class Attributes {
                    class SAVE_ENTITY {
                        displayName = SAVE_ENTITY_TEXT;
                        tooltip = SAVE_ENTITY_TIP;
                        property = QUOTE(SAVE_ENTITY);
                        control = "Checkbox";
                        expression = QUOTE(_this setVariable [ARR_3(QQGVAR(saveEntity),_value,false)]);
                        defaultValue = "false";
                        unique = 0;
                        // validate = "number";
                        condition = "1 - (objectAgent + logicModule)";
                        // typeName = "NUMBER";
                    };
                };
            };
        };
    };

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
                        expression = QUOTE([_this] call FUNC(initSafezones));
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
