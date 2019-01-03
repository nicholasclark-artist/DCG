/*
    https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes
*/

// menus
#define MAIN_FOLDER GVARMAIN(folder)
#define EXPORTFACTION_ITEM GVAR(exportFaction)
#define EXPORTFACTION_TEXT "Export Faction List"
#define EXPORTCOMP_ITEM GVAR(exportComp)
#define EXPORTCOMP_TEXT "Export Composition from Selection"

// attributes
#define SAVE_ITEM GVAR(save)
#define SAVE_TEXT "DCG - Save"
#define SAVE_ENTITY GVAR(saveEntity)
#define SAVE_ENTITY_TEXT "Save Entity"
#define SAVE_ENTITY_TIP "Add entity to save system."
#define COMP_ITEM GVAR(comp)
#define COMP_TEXT "DCG - Composition"
#define COMP_ANCHOR GVAR(anchor)
#define COMP_ANCHOR_TEXT "Composition Anchor"
#define COMP_ANCHOR_TIP "Enable to set object as composition anchor. Only one object in a composition should be the anchor."
#define COMP_VECTORUP GVAR(vectorUp)
#define COMP_VECTORUP_TEXT "Ignore Terrain Vector"
#define COMP_VECTORUP_TIP ""
#define COMP_SNAP GVAR(snap)
#define COMP_SNAP_TEXT "Snap Object to Terrain"
#define COMP_SNAP_TIP ""

class ctrlMenuStrip;
class display3DEN {
	class Controls {
		class MenuStrip: ctrlMenuStrip {
			class Items {
				class Tools {
					items[] += {QUOTE(MAIN_FOLDER)};
				};
				class MAIN_FOLDER {
					text = TITLE;
					items[] = {QUOTE(EXPORTCOMP_ITEM),QUOTE(EXPORTFACTION_ITEM)};
				};
                class EXPORTCOMP_ITEM {
                    text = EXPORTCOMP_TEXT;
                    action = QUOTE(call FUNC(exportComposition));
                };
                class EXPORTFACTION_ITEM {
                    text = EXPORTFACTION_TEXT;
                    action = QUOTE(call FUNC(exportFactionClasses));
                };
			};
		};
	};
};

class Cfg3DEN {
	class Object {
		class AttributeCategories {
			class COMP_ITEM {
				displayName = COMP_TEXT;
				collapsed = 1;
				class Attributes {
					class COMP_ANCHOR {
						displayName = COMP_ANCHOR_TEXT;
						tooltip = COMP_ANCHOR_TIP;
    					property = QUOTE(COMP_ANCHOR);
						control = "Checkbox";
						expression = "";
						defaultValue = "false";
						unique = 0;
						// validate = "number";
						condition = "1 - (objectAgent + logicModule + objectBrain)";
						// typeName = "NUMBER";
					};
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
                    class COMP_SNAP {
                        displayName = COMP_SNAP_TEXT;
                        tooltip = COMP_SNAP_TIP;
                        property = QUOTE(COMP_SNAP);
                        control = "Checkbox";
                        expression = "";
                        defaultValue = "true";
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
};
