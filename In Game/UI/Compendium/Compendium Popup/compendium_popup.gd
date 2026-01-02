extends Control
class_name CompendiumPopup

@export var tooltip : String = "Text goes here":
	set(value):
		tooltip = value
		update_text()

func _ready():
	update_text()

func update_text():
	if $Panel/MarginContainer/Label:
		$Panel/MarginContainer/Label.text = tooltip
