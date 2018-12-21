#define MAIN_FOLDER GVARMAIN(folder)
#define EXPORTFACTION_ITEM GVARMAIN(exportFaction)
#define EXPORTFACTION_TEXT "Export Faction List"
#define EXPORTCOMP_ITEM GVARMAIN(exportComp)
#define EXPORTCOMP_TEXT "Export Composition from Selection"

#define COMP_ITEM GVARMAIN(comp)
#define COMP_TEXT "DCG - Composition"
#define COMP_ANCHOR GVARMAIN(anchor)
#define COMP_ANCHOR_TEXT "Composition Anchor"
#define COMP_ANCHOR_TIP "Enable to set object as composition anchor. Only one object in a composition should be the anchor."
#define COMP_VECTORUP GVARMAIN(vectorUp)
#define COMP_VECTORUP_TEXT "Ignore Terrain Vector"
#define COMP_VECTORUP_TIP ""
#define COMP_SNAP GVARMAIN(snap)
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
						// Expression called when applying the attribute in Eden and at the scenario start
						// The expression is called twice - first for data validation, and second for actual saving
						// Entity is passed as _this, value is passed as _value
						// %s is replaced by attribute config name. It can be used only once in the expression
						// In MP scenario, the expression is called only on server.
						expression = "";
						// Expression called when custom property is undefined yet (i.e., when setting the attribute for the first time)
						// Entity is passed as _this
						// Returned value is the default value
						// Used when no value is returned, or when it's of other type than NUMBER, STRING or ARRAY
						// Custom attributes of logic entities (e.g., modules) are saved always, even when they have default value
						defaultValue = "false";
						//--- Optional properties
						unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
						// validate = "number"; // Validate the value before saving. Can be "none", "expression", "condition", "number" or "variable"
						// condition = "objectSimulated"; // Condition for attribute to appear (see the table below)
						// typeName = "NUMBER"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
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
                        // condition = "objectSimulated";
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
                        // condition = "objectSimulated";
                        // typeName = "NUMBER";
                    };
				};
			};
		};
	};
};
