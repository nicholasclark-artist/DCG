/*
	File: script_macro_voronoi.hpp
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-12
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 
*/

//Debug switch, comment to turn off
// #define DO_DEBUG 

/* =================== Pointers =================== */
#define POINTER_PREFIX "mem_"
#define PTR_NULL ""
#define PTR_IS_NULL(x) ((x) isEqualTo PTR_NULL)
#define PTR_MAIN _voronoiContainer
#define SET_PTR(x,val) ([PTR_MAIN, x , val] call FUNC(pointerSet))
#define GET_PTR(x) ([PTR_MAIN, x] call FUNC(pointerGet))
#define NEW_PTR(val) ([PTR_MAIN, val] call FUNC(pointerNew))
#define DEL_PTR(x) (SET_PTR(x,nil)) 

/* =================== Points =================== */
#define POINT_X 0
#define POINT_Y 1

#define POINT_NULL []
#define POINT_IS_NULL(x) ((x) isEqualTo POINT_NULL)

/* =================== Edges =================== */
#define EDGE_START 0
#define EDGE_END 1
#define EDGE_LEFT 2
#define EDGE_RIGHT 3
#define EDGE_NEIGHBOUR 4
#define EDGE_LINE_F 5
#define EDGE_LINE_G 6
#define EDGE_DIRECTION 7

#define EDGE_NULL []
#define EDGE_IS_NULL(x) ((x) isEqualTo EDGE_NULL)

/* =================== Events =================== */
#define EVENT_POINT 0
#define EVENT_TYPE 1
#define EVENT_Y 2
#define EVENT_ARCH 3

#define EVENT_NULL []
#define EVENT_IS_NULL(x) ((x) isEqualTo EVENT_NULL)

#define EVENT_TYPE_SITE true
#define EVENT_TYPE_CIRCLE false

/* =================== Parabolas =================== */
#define PARABOLA_SITE 0
#define PARABOLA_IS_LEAF 1
#define PARABOLA_EDGE 2
#define PARABOLA_EVENT 3
#define PARABOLA_PARENT 4
#define PARABOLA_LEFT 5
#define PARABOLA_RIGHT 6

#define PARABOLA_NULL []
#define PARABOLA_IS_NULL(x) ((x) isEqualTo PARABOLA_NULL)