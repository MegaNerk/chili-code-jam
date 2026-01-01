extends ScrollContainer
class_name Compendium

signal entry_selected(entry_ref : Unit_Res)

@export var my_grid : GridContainer
@export var compendium_button_scene : PackedScene

var my_compendium_buttons : Array[CompendiumButton]

func load_multiple_entries(new_entries : Array):
	for entry in new_entries:
		load_new_entry(entry)

func load_new_entry(new_entry : Unit_Res):
	assert(new_entry is Kaiju_Res or new_entry is Building_Res, "Tried to load illegal compendium entry")
	var new_button : CompendiumButton = compendium_button_scene.instantiate()
	my_grid.add_child(new_button)
	new_button.this_entry = new_entry
	new_button.entry_selected.connect(on_entry_selected)

func on_entry_selected(selected_entry):
	emit_signal("entry_selected", selected_entry)
