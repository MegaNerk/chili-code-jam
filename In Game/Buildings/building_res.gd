extends Unit_Res
class_name Building_Res

enum PLACEMENT {LAND, WATER, BOTH}

@export var food_cost : int = 0
@export var fear_cost : int = 0
@export var placement_type : PLACEMENT
