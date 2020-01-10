/*
Author:
Nicholas Clark (SENSEI)

Description:
get object size

Arguments:
0: object <OBJECT>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define BUFFER 1

private _bbr = 0 boundingBoxReal _this;
private _diff = (_bbr select 1) vectorDiff (_bbr select 0);

// [max radius, height]
[((abs (_diff select 0) max abs (_diff select 1)) * 0.5) + BUFFER,(_diff select 2) + BUFFER]