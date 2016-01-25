#define EXCEPT {"isNotInside", "isNotSitting"}

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class ModuleDescription {};
    };
    class DOUBLES(PREFIX,moduleLocation): Module_F { // TODO fix rpt error
        scope = 2;
        displayName = "Add Location";
        category = QUOTE(DOUBLES(PREFIX,module));
        function = QFUNC(spawnLocationFromModule);
        functionPriority = 0; // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
        isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
        isTriggerActivated = 0; // 1 for module waiting until all synced triggers are activated
        isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
        is3DEN = 0; // 1 to run init function in Eden Editor as well

        class Arguments {
            class Type {
                displayName = "Location Type";
                description = "Type of location";
                typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
                class values {
                    class Village  {
                        name = "Village";
                        value = "NameVillage";
                        default = 1;
                    };
                    class City  {
                        name = "City";
                        value = "NameCity";
                    };
                    class Capital  {
                        name = "Capital";
                        value = "NameCityCapital";
                    };
                };
            };
            class Size {
                displayName = "Location Size";
                description = "Size of location in meters(size is uniform)";
                typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
                defaultValue = 1000;
            };
            class Name {
                displayName = "Name";
                description = "Name of location";
                defaultValue = "Default Location Name";
                // When no 'values' are defined, input box is displayed instead of listbox
            };
        };

        // Module description. Must inherit from base class, otherwise pre-defined entities won't be available
        class ModuleDescription: ModuleDescription {
            description = "Add a location of the selected type on the module's position.";
            // sync[] = {}; // Array of synced entities (can contain base classes)
        };
    };
};