extends TextureButton

signal building_selected(building_ref : Building_Res)

@export var this_building : Building_Res:
	set(value):
		this_building = value
		$TextureRect.texture = this_building.art
		$Label.text = this_building.name

func on_clicked():
	emit_signal("building_selected", this_building)
