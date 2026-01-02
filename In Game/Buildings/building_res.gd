extends Unit_Res
class_name Building_Res

enum PLACEMENT {LAND, WATER, BOTH}

@export var placement_type : PLACEMENT

@export var tick_effects : Array[GameEffect]
@export_flags_2d_navigation var placable_on_region = 3 
