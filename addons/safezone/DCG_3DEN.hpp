#define SAFEZONE_ITEM ADDON
#define SAFEZONE_TEXT "DCG - Safezone"
#define SAFEZONE_CREATE DOUBLES(ADDON,create)
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
						// Expression called when applying the attribute in Eden and at the scenario start
						// The expression is called twice - first for data validation, and second for actual saving
						// Entity is passed as _this, value is passed as _value
						// %s is replaced by attribute config name. It can be used only once in the expression
						// In MP scenario, the expression is called only on server.
						expression = QUOTE(call FUNC(init));
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
				};
			};
		};
	};
};
