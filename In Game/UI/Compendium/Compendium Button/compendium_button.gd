extends TextureButton
class_name CompendiumButton

signal entry_selected(entry_ref : Unit_Res)

@export var this_entry : Unit_Res:
	set(value):
		this_entry = value
		if $TextureRect and $Label:
			$TextureRect.texture = this_entry.art
			$Label.text = this_entry.name

func _ready():
	$TextureRect.texture = this_entry.art
	$Label.text = this_entry.name

func on_clicked():
	emit_signal("entry_selected", this_entry)
