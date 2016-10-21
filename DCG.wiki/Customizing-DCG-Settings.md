### Overview and Load Order

DCG's settings are loaded on the server as config entries. After mission start, the entries are assigned as missionNamespace global variables.

There are three layers to the settings framework. The server config and mission parameters are adjustable, allowing server admins and mission designers to overwrite the mod config settings. This allows for easy customization without adding dependencies.

1. mod config
2. server config
3. mission parameters

### Server Config Setup

1. Open the optionals folder in @dcg
2. Copy *dcg_server.pbo* to the addons folder in @dcg
3. Copy the userconfig folder to the root Arma 3 folder
4. Open *serverconfig.hpp* in `\Arma 3\userconfig\dcg\` and edit the desired values

### Mission Parameters Setup
An overview of the mission parameters framework is located [here](https://community.bistudio.com/wiki/Arma_3_Mission_Parameters).
1. Create a Params class in the mission's [description.ext](https://community.bistudio.com/wiki/Description.ext)
2. Create a class with the same name as the desired setting
3. Add the **dcg_setting** entry to the class
  - allowed values are 1 (ON) and 0 (OFF)
  - **the setting will not work without this entry**
4. Add the **typeName** entry to the class

#### Parameter Example
```
class Params {
    class dcg_main_enemySide {
       title = "Enemy Side";
       values[] = {0,2};
       texts[] = {"East", "Independent"};
       default = 0;
       dcg_setting = 1;
       typeName = "SIDE";
    };
};
```

### Using TypeName
The **typeName** entry determines how DCG will process the setting's value.     
The allowed data types are `SCALAR, STRING, BOOL, SIDE, ARRAY, POOL, WORLD`.

- SCALAR
  - value is of type NUMBER
  - simple expressions are allowed
  ```
    class dcg_main_baseRadius {
        typeName = "SCALAR";
        value = (worldSize*0.055);
    };
  ```
- STRING
  - value is of type STRING
  ```
    class dcg_main_baseName {
        typeName = "STRING";
        value = "MOB Dodge";
    };
  ```
- BOOL
  - value is of type NUMBER and processed to be of type BOOLEAN, 0 (FALSE) or 1 (TRUE)
  ```
    class dcg_main_loadData {
        typeName = "BOOL";
        value = 1;
    };
  ```
- SIDE
  - value is of type NUMBER, 0 (EAST), 1 (WEST), 2 (RESISTANCE), 3 (CIVILIAN)
  ```
    class dcg_main_enemySide {
        typeName = "SIDE";
        value = 0;
    };
  ```
- ARRAY
  - value is of type ARRAY
  ```
  class dcg_main_init {
      typeName = "ARRAY";
      value[] = {
      	"ALL"
      };
  };
  ```

- POOL
  - value is a list of nested arrays containing elements of type STRING
  - the first element of each nested array is a [worldName](https://community.bistudio.com/wiki/worldName) or [missionName](https://community.bistudio.com/wiki/missionName) that the following elements will be used on, this allows mission designers to customize settings per map and per mission
  - duplicate elements are removed
  ```
  class dcg_main_unitPoolEast {
      typeName = "POOL";
      value[] = {
          {"ALL","O_soldier_AR_F","O_medic_F"}, // units used on all maps and missions
          {"ALTIS","O_Soldier_AA_F","O_support_MG_F"}, // units used only on Altis
          {"DCG_WEST","O_Soldier_AA_F","O_soldier_M_F"} // units used only in missions named dcg_west
      };
  };
  ```

- WORLD
  - value is a list of nested arrays
  - the first element of each nested array is a [worldName](https://community.bistudio.com/wiki/worldName) that the following elements will be used on, this allows mission designers to customize settings per map and per mission
  - duplicate elements are **not** removed
  ```
  class dcg_weather_mapData {
      typeName = "WORLD";
      value[] = {
      	{"ALTIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62},
      	{"STRATIS",0.67,0.65,0.56,0.52,0.44,0.34,0.26,0.27,0.33,0.47,0.54,0.62}
      };
  };
  ```
