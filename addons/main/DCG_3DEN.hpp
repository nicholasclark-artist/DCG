#define MAIN_FOLDER DOUBLES(PREFIX,Folder)
#define EXPORTSETTINGS_ITEM DOUBLES(PREFIX,ExportSettings)
#define EXPORTSETTINGS_TEXT "Export Default Settings"
#define EXPORTPOOL_ITEM DOUBLES(PREFIX,ExportPool)
#define EXPORTPOOL_TEXT "Export Pool from Selection"

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
					items[] = {QUOTE(EXPORTSETTINGS_ITEM),QUOTE(EXPORTPOOL_ITEM)};
				};
                class EXPORTSETTINGS_ITEM {
                    text = EXPORTSETTINGS_TEXT;
                    action = QUOTE(call FUNC(exportSettings));
                };
				class EXPORTPOOL_ITEM {
					text = EXPORTPOOL_TEXT;
                    action = QUOTE(call FUNC(exportPool));
				};
			};
		};
	};
};
