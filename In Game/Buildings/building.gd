extends RefCounted
class_name Building

signal destroyed

var my_building_res : Building_Res

var id : int

var name : String = "City Name"
var art : Texture2D = null

func _init(building_res : Building_Res):
	if building_res:
		my_building_res = building_res
		name = my_building_res.name
		art = my_building_res.art

func process_tick(tick_updates : Array[GameEffect]) -> Array[GameEffect]:
	tick_updates.append_array(my_building_res.tick_effects)
	return tick_updates

func destroy():
	emit_signal("destroyed")
