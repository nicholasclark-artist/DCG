/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize settings via CBA framework

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

[
    QGVAR(enable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    format ["Enable %1", COMPONENT_NAME], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet01),
    "EDITBOX",
    ["Comms Network 01","Units included in this list will be assigned to network. Units must be separated by a comma."],
    COMPONENT_NAME,
    "plt_pl, a_sl, b_sl",
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet02),
    "EDITBOX",
    ["Comms Network 02","Units included in this list will be assigned to network. Units must be separated by a comma."],
    COMPONENT_NAME,
    "plt_fo, r1_pilot, r1_copilot, r2_pilot, r2_copilot, rh1_co",
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet03),
    "EDITBOX",
    ["Comms Network 03","Units included in this list will be assigned to network. Units must be separated by a comma."],
    COMPONENT_NAME,
    "plt_pl, plt_sgt, plt_med, plt_fo",
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet04),
    "EDITBOX",
    ["Comms Network 04","Units included in this list will be assigned to network. Units must be separated by a comma."],
    COMPONENT_NAME,
    "a_sl, a_med, a1_ftl, a1_ar, a1_gr, a1_r, a2_ftl, a2_ar, a2_gr, a2_r",
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet05),
    "EDITBOX",
    ["Comms Network 05","Units included in this list will be assigned to network. Units must be separated by a comma."],
    COMPONENT_NAME,
    "b_sl, b_med, b1_ftl, b1_ar, b1_gr, b1_r, b2_ftl, b2_ar, b2_gr, b2_r",
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet06),
    "EDITBOX",
    ["Comms Network 06","Units included in this list will be assigned to network. Units must be separated by a comma."],
    COMPONENT_NAME,
    "rh1_co, rh1_driver, rh1_gunner",
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet01_ACRE),
    "LIST",
    ["Network 01 ACRE2 Radio", "ACRE2 radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_PRC148","ACRE_SEM52SL"],
        ["AN/PRC-343 PRR","AN/PRC-152","AN/PRC-117F","AN/PRC-77","AN/PRC-148","SEM 52 SL"],
        1
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet01_TFAR),
    "LIST",
    ["Network 01 TFAR Radio", "TFAR radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["tf_anprc152","tf_rf7800str","tf_rt1523g","tf_anprc148jem","tf_anprc154","tf_anprc155","tf_fadak","tf_pnr1000a","tf_mr3000"],
        ["AN/PRC-152","RF-7800S-TR","RT-1523G (ASIP)","AN/PRC148-JEM","AN/PRC-154","AN/PRC-155","FADAK","PNR-1000A","MR3000"],
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet02_ACRE),
    "LIST",
    ["Network 02 ACRE2 Radio", "ACRE2 radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_PRC148","ACRE_SEM52SL"],
        ["AN/PRC-343 PRR","AN/PRC-152","AN/PRC-117F","AN/PRC-77","AN/PRC-148","SEM 52 SL"],
        2
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet02_TFAR),
    "LIST",
    ["Network 02 TFAR Radio", "TFAR radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["tf_anprc152","tf_rf7800str","tf_rt1523g","tf_anprc148jem","tf_anprc154","tf_anprc155","tf_fadak","tf_pnr1000a","tf_mr3000"],
        ["AN/PRC-152","RF-7800S-TR","RT-1523G (ASIP)","AN/PRC148-JEM","AN/PRC-154","AN/PRC-155","FADAK","PNR-1000A","MR3000"],
        2
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet03_ACRE),
    "LIST",
    ["Network 03 ACRE2 Radio", "ACRE2 radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_PRC148","ACRE_SEM52SL"],
        ["AN/PRC-343 PRR","AN/PRC-152","AN/PRC-117F","AN/PRC-77","AN/PRC-148","SEM 52 SL"],
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet03_TFAR),
    "LIST",
    ["Network 03 TFAR Radio", "TFAR radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["tf_anprc152","tf_rf7800str","tf_rt1523g","tf_anprc148jem","tf_anprc154","tf_anprc155","tf_fadak","tf_pnr1000a","tf_mr3000"],
        ["AN/PRC-152","RF-7800S-TR","RT-1523G (ASIP)","AN/PRC148-JEM","AN/PRC-154","AN/PRC-155","FADAK","PNR-1000A","MR3000"],
        1
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet04_ACRE),
    "LIST",
    ["Network 04 ACRE2 Radio", "ACRE2 radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_PRC148","ACRE_SEM52SL"],
        ["AN/PRC-343 PRR","AN/PRC-152","AN/PRC-117F","AN/PRC-77","AN/PRC-148","SEM 52 SL"],
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet04_TFAR),
    "LIST",
    ["Network 04 TFAR Radio", "TFAR radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["tf_anprc152","tf_rf7800str","tf_rt1523g","tf_anprc148jem","tf_anprc154","tf_anprc155","tf_fadak","tf_pnr1000a","tf_mr3000"],
        ["AN/PRC-152","RF-7800S-TR","RT-1523G (ASIP)","AN/PRC148-JEM","AN/PRC-154","AN/PRC-155","FADAK","PNR-1000A","MR3000"],
        1
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet05_ACRE),
    "LIST",
    ["Network 05 ACRE2 Radio", "ACRE2 radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_PRC148","ACRE_SEM52SL"],
        ["AN/PRC-343 PRR","AN/PRC-152","AN/PRC-117F","AN/PRC-77","AN/PRC-148","SEM 52 SL"],
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet05_TFAR),
    "LIST",
    ["Network 05 TFAR Radio", "TFAR radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["tf_anprc152","tf_rf7800str","tf_rt1523g","tf_anprc148jem","tf_anprc154","tf_anprc155","tf_fadak","tf_pnr1000a","tf_mr3000"],
        ["AN/PRC-152","RF-7800S-TR","RT-1523G (ASIP)","AN/PRC148-JEM","AN/PRC-154","AN/PRC-155","FADAK","PNR-1000A","MR3000"],
        1
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet06_ACRE),
    "LIST",
    ["Network 06 ACRE2 Radio", "ACRE2 radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["ACRE_PRC343","ACRE_PRC152","ACRE_PRC117F","ACRE_PRC77","ACRE_PRC148","ACRE_SEM52SL"],
        ["AN/PRC-343 PRR","AN/PRC-152","AN/PRC-117F","AN/PRC-77","AN/PRC-148","SEM 52 SL"],
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(commNet06_TFAR),
    "LIST",
    ["Network 06 TFAR Radio", "TFAR radio for units assigned to network."],
    COMPONENT_NAME,
    [
        ["tf_anprc152","tf_rf7800str","tf_rt1523g","tf_anprc148jem","tf_anprc154","tf_anprc155","tf_fadak","tf_pnr1000a","tf_mr3000"],
        ["AN/PRC-152","RF-7800S-TR","RT-1523G (ASIP)","AN/PRC148-JEM","AN/PRC-154","AN/PRC-155","FADAK","PNR-1000A","MR3000"],
        1
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
