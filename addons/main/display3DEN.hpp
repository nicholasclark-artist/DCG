#define MAIN_FOLDER GVARMAIN(folder)

#define EXPORTFACTION_ITEM GVAR(exportFaction)
#define EXPORTFACTION_TEXT "Export Faction List"

#define EXPORTCOMP_ITEM GVAR(exportComp)
#define EXPORTCOMP_TEXT "Export Composition from Selection"

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