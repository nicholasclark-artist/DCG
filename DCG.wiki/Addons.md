- Addons
	- [dcg_main](#dcg_main)
	- [dcg_approval](#dcg_approval)
	- [dcg_cache](#dcg_cache)
	- [dcg_civilian](#dcg_civilian)
	- [dcg_fob](#dcg_fob)
	- [dcg_ied](#dcg_ied)
	- [dcg_occupy](#dcg_occupy)
	- [dcg_patrol](#dcg_patrol)
	- [dcg_radio](#dcg_radio)
	- [dcg_respawn](#dcg_respawn)
	- [dcg_server](#dcg_server)
	- [dcg_task](#dcg_task)
	- [dcg_transport](#dcg_transport)
	- [dcg_weather](#dcg_weather)

***

### dcg_main
dependencies: cba

common functions and settings used by other addons

| setting        | description  |
| ------------- |-------------|
| dcg_main_init | list of map and mission names where dcg is enabled |
| dcg_main_debug | enable/disable debug mode |
| dcg_main_loadData | load data saved to server's profile, data is mission specific |
| dcg_main_baseName | main base name |
| dcg_main_baseRadius | main base radius |
| dcg_main_baseSafezone | enable/disable main base safezone, enemies and tasks cannot spawn in safezone |
| dcg_main_blacklistLocations | list of city names that dcg will exclude from all addons |
| dcg_main_unitPool | list of units used in all addons, actual setting is side specific |
| dcg_main_vehPool | list of land vehicles used in all addons, actual setting is side specific |
| dcg_main_airPool | list of air vehicles used in all addons, actual setting is side specific |
| dcg_main_sniperPool | list of sniper units used in all addons, actual setting is side specific |
| dcg_main_officerPool | list of officer units used in all addons, actual setting is side specific |

***

### dcg_approval
dependencies: cba, dcg_main

region based approval tracking, unit questioning and hostile civilians

| setting        | description  |
| ------------- |-------------|
| dcg_approval_enable | enable/disable addon |
| dcg_approval_multiplier | approval progression multiplier |
| dcg_approval_hostileCooldown | time in seconds between potential hostile civilian spawns |

***

### dcg_cache
dependencies: cba, dcg_main

adds unit and vehicle caching system to improve performance

| setting        | description  |
| ------------- |-------------|
| dcg_cache_enable | enable/disable addon |
| dcg_cache_dist | distance at which units will be cached |

***

### dcg_civilian
dependencies: cba, dcg_main

civilian unit, vehicle and animal spawn system

| setting        | description  |
| ------------- |-------------|
| dcg_civilian_enable | enable/disable addon |
| dcg_civilian_spawnDist | distance from location that civilians will spawn |
| dcg_civilian_countCapital | capital type location unit count |
| dcg_civilian_countCity | city type location unit count |
| dcg_civilian_countVillage | village type location unit count |
| dcg_civilian_vehMaxCount | max number of civilian vehicles allowed on map at any given time |
| dcg_civilian_vehCooldown | time in seconds between potential civilian vehicle spawns |

***

### dcg_fob
dependencies: cba, dcg_main

adds the ability to create a forward operating base

| setting        | description  |
| ------------- |-------------|
| dcg_fob_enable | enable/disable addon |
| dcg_fob_name | forward operating base name |
| dcg_fob_range | forward operating base size |
| dcg_fob_placingMultiplier | cost multiplier for placing objects in fob interface, should be a negative number |
| dcg_fob_deletingMultiplier | cost multiplier for deleting objects in fob interface, should be a positive number |

***

### dcg_ied
dependencies: cba, dcg_main

spawns roadside IEDs throughout the map

| setting        | description  |
| ------------- |-------------|
| dcg_ied_enable | enable/disable addon |

***

### dcg_occupy
dependencies: cba, dcg_main

introduces occupied map locations (villages, cities, capitals) fortified by enemy units

| setting        | description  |
| ------------- |-------------|
| dcg_occupy_enable | enable/disable addon |
| dcg_occupy_cooldown | time in seconds between occupation of map locations |
| dcg_occupy_locationCount | number of locations to be occupied at once |
| dcg_occupy_infCount | enemy unit count in location, actual setting is type specific |
| dcg_occupy_vehCount | enemy land vehicle count in location, actual setting is type specific |
| dcg_occupy_airCount | enemy air vehicle count in location, actual setting is type specific |

***

### dcg_patrol
dependencies: cba, dcg_main

enemy unit and vehicle spawn system

| setting        | description  |
| ------------- |-------------|
| dcg_patrol_enable | enable/disable addon |
| dcg_patrol_cooldown | time in seconds between potential patrol spawns |
| dcg_patrol_groupsMaxCount | max number of patrols allowed on map at any given time |
| dcg_patrol_vehChance | chance of spawning vehicle patrol |

***

### dcg_radio
dependencies: cba, dcg_main

handles acre2 and tfar integration

| setting        | description  |
| ------------- |-------------|
| dcg_radio_enable | enable/disable addon |
| dcg_radio_commNet | list of players assigned to communications network, actual setting is split into multiple networks |
| dcg_radio_commNet_ACRE | classname of ACRE2 radio used for specific comms. network |
| dcg_radio_commNet_TFAR | classname of TFAR radio used for specific comms. network |

***

### dcg_respawn
dependencies: cba, dcg_main

restores player loadout on respawn

| setting        | description  |
| ------------- |-------------|
| dcg_respawn_enable | enable/disable addon |

***

### dcg_server
dependencies: cba, dcg_main

includes server config settings from `\Arma 3\userconfig\dcg\serverconfig.hpp`

***

### dcg_task
dependencies: cba, dcg_main

spawns primary and secondary cooperative tasks that scale based on player count

| setting        | description  |
| ------------- |-------------|
| dcg_task_enable | enable/disable addon |
| dcg_task_cooldown | time in seconds between task spawns |

***

### dcg_transport
dependencies: cba, dcg_main

adds the ability to call an AI controlled transport to taxi players around map

| setting        | description  |
| ------------- |-------------|
| dcg_transport_enable | enable/disable addon |
| dcg_transport_maxCount | max number of transport vehicles allowed on map at any given time |
| dcg_transport_cooldown | time in seconds between transport requests |

***

### dcg_weather
dependencies: cba, dcg_main

sets the weather based on geographical location, season and time of day

| setting        | description  |
| ------------- |-------------|
| dcg_weather_enable | enable/disable addon |
| dcg_weather_season | season to set at mission start (-1 = random, 0 = summer, 1 = fall, 2 = winter, 3 = spring) |
| dcg_weather_time | time of day to set at mission start (-1 = random, 0 = morning, 1 = midday, 2 = evening, 3 = night) |
| dcg_weather_mapData | list of weather data by map name, array elements represent average cloud coverage in a given month |

***
