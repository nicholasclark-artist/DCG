Dynamic Combat Generator allows mission makers to quickly populate their cooperative scenarios with content, however, there are a few steps to get everything running smoothly.

1. In the mission's init.sqf, assign the setting, **dcg_main_enemySide** (default EAST), to the enemy's [side](https://community.bistudio.com/wiki/Side_relations)
  - `dcg_main_enemySide = EAST;`
2. Assign the setting, **dcg_main_playerSide** (default WEST), to the player's [side](https://community.bistudio.com/wiki/Side_relations)
  - `dcg_main_playerSide = WEST;`
3. If you would like DCG to recognize an area of the map as the player's main base, create a marker or an object named **dcg_base** in the editor.
    - If **dcg_base** is an object, the main base and safezone will follow the object's position.
    - Tasks will not spawn inside the main base.
    - Enemies will not spawn inside the main base.
    - Enemies that wander into the main base will be deleted if **dcg_main_baseSafezone** is enabled.

*Settings such as **dcg_main_baseSafezone** are easily customizable using the settings framework - See [Customizing DCG Settings](https://github.com/nicholasclark-artist/DCG/wiki/Customizing-DCG-Settings).*
