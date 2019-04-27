/*
Author:
Nicholas Clark (SENSEI)

Description:
get data for animation objects 

Arguments:
0: model info <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define ANIMS_SEAT ["HubSittingChairA_idle1","HubSittingChairA_idle2","HubSittingChairA_idle3","HubSittingChairB_idle1","HubSittingChairB_idle2","HubSittingChairB_idle3"]
#define ANIMS_WALL ["InBaseMoves_Lean1"]

params ["_modelInfo"];

// [modelspace offset, direction offset, animations]
switch (_modelInfo select 0) do {
    // chairs
    case "campingchair_v1_f.p3d": {
        [[0,-0.1,0],180,ANIMS_SEAT]
    };
    case "campingchair_v2_f.p3d": {
        [[0,-0.1,0],180,ANIMS_SEAT]
    };
    case "chairplastic_f.p3d": {
        [[0,0,0],90,ANIMS_SEAT]
    };
    case "chairwood_f.p3d": {
        [[0,-0.05,0],180,ANIMS_SEAT]
    };
    case "officechair_01_f.p3d": {
        [[0,0,0],180,ANIMS_SEAT]
    };
    case "woodenlog_f.p3d": {
        [[0,0,0],0,ANIMS_SEAT]
    };
    case "rattanchair_01_f.p3d": {
        [[0,0,0],180,ANIMS_SEAT]
    };
    case "armchair_01_f.p3d": {
        [[0,0,0],0,ANIMS_SEAT]
    };

    // benches
    case "bench_f.p3d": {
        [[0.5,-0.04,0],180,ANIMS_SEAT]
    };
    case "bench_01_f.p3d": {
        [[0.5,-0.04,0],180,ANIMS_SEAT]
    };
    case "bench_02_f.p3d": {
        [[-0.5,-0.04,0],180,ANIMS_SEAT]
    };
    case "bench_03_f.p3d": {
        [[-0.5,-0.15,0],180,ANIMS_SEAT]
    };
    case "bench_05_f.p3d": {
        [[0.5,-0.04,0],0,ANIMS_SEAT]
    };

    default {
        []
    };
};