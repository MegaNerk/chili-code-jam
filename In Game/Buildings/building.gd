extends RefCounted
class_name Building

var my_building_res : Building_Res

var name : String = "City Name"
var art : Texture2D = null

func _init(building_res : Building_Res):
	if building_res:
		my_building_res = building_res
		name = my_building_res.name
		art = my_building_res.art
