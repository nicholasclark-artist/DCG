/*
Author: SENSEI, Silola (data collected using x-cam)

Last modified: 7/17/2015

Description: spawns small base

Return: array
__________________________________________________________________*/
if !(isServer) exitWith {};

private ["_newOrigin","_obj","_dat","_objArray","_adString","_cString","_newPos","_moveTo","_origin","_diffFromOriginX","_diffFromOriginY","_diffFromOriginZ","_datAnchor","_originGrp","_diffX","_diffY","_diffZ"];

_newOrigin = _this select 0;
_obj = objNull;
_dat = [];
_objArray = [];
_adString = "CAN_COLLIDE";

_cString = {
    _newPos = call _moveTo;
    _obj = createVehicle [(_dat select 0), _newPos, [], 0, _adString];
    _objArray pushBack _obj;
    if((_dat select 4) isEqualTo 0) then {_obj enableSimulationGlobal false};
    _obj setdir (_dat select 2);
/*    if((_dat select 3) isEqualTo -100) then {
        _obj setposATL _newPos;
    } else {
        _obj setposASL [(_newPos select 0),(_newPos select 1),(_dat select 3)];
    };*/
    _obj setposATL _newPos;
    if((_dat select 5) isEqualTo 0) then {
        _obj setVectorUp [0,0,1]
    } else {
        _obj setVectorUp (surfacenormal (getPosATL _obj))
    };
    if(count (_dat select 6) > 0) then {{call _x} foreach (_dat select 6)};
};

_moveTo = {
    _origin = call compile (_dat select 1);
    _diffFromOriginX = 0;
    _diffFromOriginY = 0;
    _diffFromOriginZ = 0;

    if !(isNil "_datAnchor") then {
        _originGrp = call compile (_datAnchor select 1);
        _diffFromOriginX = (_origin select 0) - (_originGrp select 0);
        _diffFromOriginY = (_origin select 1) - (_originGrp select 1);
        _diffFromOriginZ = (_origin select 2) - (_originGrp select 2);
    };

    _diffX = ((_newOrigin select 0) - (_origin select 0)) + _diffFromOriginX;
    _diffY = ((_newOrigin select 1) - (_origin select 1)) + _diffFromOriginY;
    _diffZ = ((_newOrigin select 2) - (_origin select 2)) + _diffFromOriginZ;
    _newPos = [(_origin select 0) + _diffX,(_origin select 1) + _diffY,(_origin select 2) + _diffZ];

    _newPos
};

_dat = ["Land_HelipadCircle_F","[23457.0292969,17694.699219,0]",179.553,-100,1,0,[]];call _cString;_datAnchor = _dat;
_dat = ["Land_Cargo20_red_F","[23459.701172,17652.546875,0]",272.121,-100,1,1,[{_obj enableSimulationGlobal false}]];call _cString;
_dat = ["Land_HBarrierBig_F","[23441.109375,17646.568359,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23440.486328,17646.351563,2.07171]",269.886,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23458.0292969,17637.654297,-0.18442]",175.182,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23458.691406,17637.697266,2.05893]",177.834,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23438.912109,17646.404297,2.07171]",266.729,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo_HQ_V3_F","[23468.623047,17648.359375,0]",270,3.19,1,0,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23437.261719,17646.523438,2.07171]",-436.73,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23452.921875,17633.923828,-0.18442]",271.387,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23436.132813,17647.791016,2.07171]",-383.384,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.835938,17649.339844,2.07171]",-450.114,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17651.742188,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.714844,17650.753906,2.07171]",-540.114,-100,1,1,[]];call _cString;
_dat = ["Land_SolarPanel_2_F","[23470.626953,17653.238281,4.45985]",270,7.64985,1,0,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.646484,17652.324219,2.07171]",179.886,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17643.150391,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.669922,17653.740234,2.07171]",-455.392,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.822266,17655.222656,2.07171]",104.949,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23455.207031,17629.138672,2.05893]",177.159,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.791016,17656.691406,2.07171]",-540.114,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23456.564453,17629.384766,-0.18442]",181.01,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23433.492188,17646.994141,0]",90.0129,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23461.587891,17630.00195313,-0.000549316]",78.0303,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17660.333984,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17634.558594,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.628906,17650.15625,2.05893]",270.405,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17652.0253906,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17643.433594,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.669922,17655.835938,2.05893]",-89.5954,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23435.986328,17665.966797,2.05893]",269.558,-100,1,1,[]];call _cString;
_dat = ["Land_SolarPanel_2_F","[23442.03125,17671.816406,4.45985]",90,7.64985,1,0,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17660.617188,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.710938,17661.515625,2.05893]",-89.5954,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17668.923828,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23477.0078125,17635.408203,2.07171]",177.298,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23433.720703,17629.980469,0]",87.9295,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23472.611328,17629.462891,2.07171]",269.974,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17634.841797,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23477.107422,17633.871094,2.07171]",177.298,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23456.554688,17620.767578,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23473.841797,17629.349609,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23474.162109,17629.314453,2.07171]",-453.119,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23447.962891,17620.765625,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17625.96875,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23477.117188,17632.335938,2.07171]",182.285,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23435.917969,17671.617188,2.05893]",-450.884,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23475.714844,17629.498047,2.07171]",266.881,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23476.951172,17630.435547,2.07171]",-537.715,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.751953,17667.195313,2.05893]",270.405,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo_HQ_V3_F","[23443.982422,17677.101563,0]",90,3.19,1,0,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23465.146484,17620.765625,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23456.921875,17618.392578,0]",-2.0958,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23448.464844,17618.0839844,0]",357.904,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23439.375,17620.767578,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17669.208984,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_CncShelter_F","[23478.945313,17629.738281,0]",90.4805,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23465.0839844,17618.621094,0]",356.831,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23434.306641,17621.421875,0]",85.7199,-100,1,1,[]];call _cString;
_dat = ["Land_Razorwire_F","[23440.046875,17618.130859,0]",-0.328123,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23435.923828,17677.273438,2.05893]",-449.495,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.792969,17672.875,2.05893]",270.405,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17677.517578,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23473.740234,17620.765625,-0.18442]",180,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo20_red_F","[23470.619141,17678.857422,0]",0.70789,-100,1,1,[{_obj enableSimulationGlobal false}]];call _cString;
_dat = ["Land_Razorwire_F","[23473.46875,17618.740234,0]",-0.39125,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo20_red_F","[23470.662109,17681.71875,0]",0.70789,-100,1,1,[{_obj enableSimulationGlobal false}]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17677.800781,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_CncShelter_F","[23478.792969,17620.775391,0]",90.4805,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo20_red_F","[23470.5,17684.640625,0]",1.97052,-100,1,1,[{_obj enableSimulationGlobal false}]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17686.111328,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.820313,17684.212891,2.05893]",-89.2166,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17686.392578,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.929688,17689.892578,2.05893]",-88.901,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23436.173828,17694.273438,2.05893]",-269.937,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17694.701172,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17694.984375,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.816406,17695.132813,2.05893]",269.647,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23436.179688,17699.953125,2.05893]",-269.937,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo20_blue_F","[23474.148438,17700.84375,0]",272.121,-100,1,1,[{_obj enableSimulationGlobal false}]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.78125,17700.939453,2.05893]",-90.353,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17703.292969,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23436.0820313,17705.511719,2.05893]",89.242,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17703.576172,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23436.574219,17708.861328,2.07171]",-361.351,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.746094,17706.746094,2.05893]",269.647,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23435.949219,17711.884766,-0.18442]",270,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23435.837891,17712.3125,2.05893]",89.3683,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23476.898438,17712.167969,-0.18442]",90,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23476.914063,17712.876953,2.05893]",-93.3834,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23455.183594,17717.382813,2.05893]",179.811,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23456.292969,17717.369141,-0.18442]",0,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23449.84375,17717.425781,2.05893]",-180.505,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23447.701172,17717.369141,-0.18442]",0,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23460.990234,17717.402344,2.05893]",179.811,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23444.164063,17717.34375,2.05893]",-180.821,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23435.570313,17715.945313,2.07171]",-307.942,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23464.884766,17717.369141,-0.18442]",0,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23466.796875,17717.421875,2.05893]",179.811,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23439.109375,17717.369141,-0.18442]",0,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23438.484375,17717.269531,2.05893]",-180.758,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_5_F","[23472.476563,17717.441406,2.05893]",179.811,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23476.0410156,17716.427734,2.07171]",-376.882,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrierBig_F","[23473.472656,17717.367188,-0.18442]",359.858,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo_House_V3_F","[23443.396484,17691.582031,0]",630.056,-100,1,0,[]];call _cString;
_dat = ["Land_Cargo_House_V3_F","[23443.40625,17700.777344,0]",270.056,-100,1,0,[]];call _cString;
_dat = ["Land_Cargo_House_V3_F","[23443.416016,17710.0292969,0]",270.056,-100,1,0,[]];call _cString;
_dat = ["Land_Medevac_house_V1_F","[23468.322266,17669.0742188,0]",89.547,3.19,1,0,[]];call _cString;
_dat = ["Land_BagBunker_Small_F","[23464.482422,17630.898438,0]",359.547,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23467.443359,17629.373047,-0.000549316]",96.1103,-100,1,1,[]];call _cString;
_dat = ["Land_HBarrier_1_F","[23469.0332031,17629.287109,-0.000549316]",96.1103,-100,1,1,[]];call _cString;
_dat = ["Land_Cargo_Patrol_V3_F","[23440.773438,17641.951172,0]",87.159,3.19,1,0,[]];call _cString;
_dat = ["Land_Cargo_Patrol_V3_F","[23471.357422,17712.322266,0]",267.159,-100,1,0,[]];call _cString;
_dat = ["CamoNet_OPFOR_open_F","[23441.619141,17655.828125,0]",267.159,-100,1,0,[]];call _cString;
_dat = ["CamoNet_OPFOR_big_Curator_F","[23468.583984,17668.0703125,2.38419e-007]",105.175,3.19,1,0,[]];call _cString;
_dat = ["Land_LampHalogen_F","[23456.777344,17633.601563,0]",340.934,-100,1,0,[]];call _cString;
_dat = ["Land_LampHalogen_F","[23438.292969,17715.337891,0]",205.934,-100,1,0,[]];call _cString;
_dat = ["Land_LampHalogen_F","[23473.279297,17688.857422,0]",9.32696,-100,1,0,[]];call _cString;
_dat = ["Land_Net_Fence_Gate_F","[23477.617188,17625.330078,0]",451.561,-100,1,1,[]];call _cString;
_dat = ["Land_Net_Fence_Gate_F","[23453.564453,17624.960938,0]",91.5607,-100,1,1,[]];call _cString;
_dat = ["Land_Sign_WarningMilitaryArea_F","[23480.609375,17629.794922,0]",631.561,-100,1,1,[]];call _cString;
_dat = ["Land_Sign_WarningMilitaryArea_F","[23480.332031,17620.677734,0]",271.561,-100,1,1,[]];call _cString;
_dat = ["Land_GymBench_01_F","[23440.482422,17653.234375,0]",249.215,3.19,1,0,[]];call _cString;
_dat = ["Land_Cargo_Patrol_V3_F","[23472.214844,17633.892578,0]",267.159,3.19,1,0,[]];call _cString;
_dat = ["Land_MapBoard_F","[23440.910156,17658.392578,-2.38419e-007]",312.834,-100,1,0,[]];call _cString;
_dat = ["MapBoard_seismic_F","[23440.306641,17656.515625,-2.38419e-007]",267.834,-100,1,0,[]];call _cString;
_dat = ["Land_ChairPlastic_F","[23443.0820313,17658.0527344,0]",177.834,-100,1,0,[]];call _cString;
_dat = ["Land_Sink_F","[23442.476563,17650.998047,0]",177.834,-100,1,0,[]];call _cString;
_dat = ["Land_CampingChair_V2_F","[23445.722656,17651.384766,0]",230.037,-100,1,0,[]];call _cString;
_dat = ["Land_CampingChair_V2_F","[23445.259766,17652.330078,0]",264.605,-100,1,0,[]];call _cString;
_dat = ["Land_LampHalogen_F","[23438.0371094,17622.673828,0]",893.73,-100,1,0,[]];call _cString;

_objArray