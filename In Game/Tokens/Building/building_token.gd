extends TokenPin
class_name BuildingPin

var my_building : Building

func _ready():
	super()
	if my_building:
		self.texture = my_building.art
