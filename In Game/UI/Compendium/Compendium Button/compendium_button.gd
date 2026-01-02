extends TextureButton
class_name CompendiumButton

signal entry_selected(entry_ref : Unit_Res)
signal entry_hovered(entry_ref : Unit_Res)
signal entry_hover_stopped(entry_ref : Unit_Res)

@export var this_entry : Unit_Res:
	set(value):
		this_entry = value
		sync_with_entry()
		if this_entry is Kaiju_Res:
			this_entry.lost_discount.connect(sync_with_entry)

@export var food_label : Label
@export var fear_label : Label

func _ready():
	if this_entry:
		sync_with_entry()
		if this_entry is Kaiju_Res:
			this_entry.lost_discount.connect(sync_with_entry)

func on_clicked():
	emit_signal("entry_selected", this_entry)

func sync_with_entry():
	if this_entry:
		$TextureRect.texture = this_entry.art
		$Label.text = this_entry.name
		if this_entry is Kaiju_Res and this_entry.has_first_kaiju_discount:
			food_label.text = "0"
			fear_label.text = "0"
		else:
			food_label.text = str(this_entry.food_cost)
			fear_label.text = str(this_entry.fear_cost)

func _on_mouse_entered():
	emit_signal("entry_hovered", this_entry)

func _on_mouse_exited():
	emit_signal("entry_hover_stopped", this_entry)
