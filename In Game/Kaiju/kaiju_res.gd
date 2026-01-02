extends Unit_Res
class_name Kaiju_Res

enum KAIJU_TYPE {LAND, WATER, AIR}

@export var food_cost : int = 0
@export var fear_cost : int = 0

@export var type : KAIJU_TYPE
@export var base_hp : float = 100
@export var hp_scaling : float = 1
@export var max_hunger : float = 100
@export var hunger_scaling : float = 1
@export var city_damage : float = 0.0001
@export var city_damage_scaling : float = 0.0001
@export var pop_damage : float = 0.0001
@export var pop_damage_scaling : float = 0.0001
@export var land_speed : float = 100
@export var land_speed_scaling : float = 1
@export var water_speed : float = 100
@export var water_speed_scaling : float = 1
@export var xp_per_level : float = 100
