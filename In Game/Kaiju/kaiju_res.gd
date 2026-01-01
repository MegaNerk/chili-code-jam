extends Unit_Res
class_name Kaiju_Res

enum KAIJU_TYPE {LAND, WATER, AIR}

@export var type : KAIJU_TYPE
@export var base_hp : int
@export var max_hunger : int
@export var base_damage : int
@export var land_speed : float = 100
@export var water_speed : float = 100
