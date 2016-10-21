[icon_attack]: https://community.bistudio.com/wikidata/images/c/c9/bis_tasktype_attack.png "icon_attack"
[icon_defend]: https://community.bistudio.com/wikidata/images/6/6a/bis_tasktype_defend.png "icon_defend"
[icon_destroy]: https://community.bistudio.com/wikidata/images/f/f8/bis_tasktype_destroy.png "icon_destroy"
[icon_kill]: https://community.bistudio.com/wikidata/images/e/e7/bis_tasktype_kill.png "icon_kill"
[icon_run]: https://community.bistudio.com/wikidata/images/2/27/bis_tasktype_run.png "icon_run"
[icon_meet]: https://community.bistudio.com/wikidata/images/1/1d/bis_tasktype_meet.png "icon_meet"
[icon_repair]: https://community.bistudio.com/wikidata/images/c/cb/bis_tasktype_repair.png "icon_repair"
[icon_search]: https://community.bistudio.com/wikidata/images/0/0e/bis_tasktype_search.png "icon_search"

### Overview
DCG's task framework consists of two categories. **Primary tasks** are involved scenarios that require a group of players to successfully coordinate. While, **secondary tasks** are smaller endeavors that can be accomplished by a single player. These categories allow the task framework to accommodate a range of player counts. The framework also adjust the number of units present per task based on the current player count.

*The requirements of a task may be affected by the mods. For example, ACE3 changes several ARMA systems, so please take your mod settings into account when performing a task.*

### Admin Actions
A server admin can cancel a task at any time through the action menu (or self interaction menu if ACE3 is enabled). A new task will spawn 30 seconds after cancelation.

### Approval Influence
Completing or failing a task influences the region's approval value if the approval addon is enabled; this affects how players interact with civilians in the area.

### Task Types
| Type      | Icon              | Description                                                                                                                                                                   | Success State                                         | Fail State                                       |
|-----------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|--------------------------------------------------|
| Attack    | ![][icon_attack]  | Attack a location occupied by enemies                                                                                                                                         | All enemies are eliminated or surrender               | N/A                                              |
| Defend    | ![][icon_defend]  | Defend a location                                                                                                                                                             | All enemies are eliminated or countdown timer expires | All players in the immediate area are eliminated |
| Destroy   | ![][icon_destroy] | Destroy an emplacement or object                                                                                                                                              | Emplacement/object is destroyed                       | Countdown timer expires (if applicable)          |
| Eliminate | ![][icon_kill]    | Eliminate a target                                                                                                                                                            | Target is eliminated                                  | N/A                                              |
| Deliver   | ![][icon_run]     | Deliver supplies to a marked location                                                                                                                                           | Supplies are safely delivered to location             | Supplies are destroyed before reaching location  |
| Rescue    | ![][icon_meet]    | Rescue target and safely transport to a marked location *(requires ACE3 for unit handling)*                                                                                                         | Target is safely transported to location              | Target is killed before reaching location        |
| Repair    | ![][icon_repair]  | <div>Repair damaged vehicle</div><div>In vanilla ARMA, requires a specialist and a toolkit</div><div>If ACE3 is enabled, requirements are dependent on server settings</div> | Vehicle is safely repaired                            | Vehicle is destroyed                             |
| Find      | ![][icon_search]  | Find a location, unit or object                                                                                                                                               | Player finds the target (and interacts with target if applicable)                              | N/A                                              |
