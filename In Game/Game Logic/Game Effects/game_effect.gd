extends Resource
class_name GameEffect

enum EFFECT_TYPE {
	RESOURCE_DELTA,
	KAIJU_HP_DELTA,
	KAIJU_HUNGER_DELTA,
	KAIJU_XP_DELTA,
	CITY_POP_DELTA,
	CITY_DEV_DELTA
}

@export var type : EFFECT_TYPE
@export var payload : Dictionary
