class Extended_PreInit_EventHandlers {
    class ADDON { 
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};
class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};
class Extended_Killed_EventHandlers {
    class CAManBase {
        class ADDON {
            killed = QUOTE(_this call FUNC(handleKilled));
        };
    };
    class Car {
        class ADDON {
            killed = QUOTE(_this call FUNC(handleKilled));
        };
    };
    class Tank {
        class ADDON {
            killed = QUOTE(_this call FUNC(handleKilled));
        };
    };
    class Air {
        class ADDON {
            killed = QUOTE(_this call FUNC(handleKilled));
        };
    };
    class Ship {
        class ADDON {
            killed = QUOTE(_this call FUNC(handleKilled));
        };
    };
};