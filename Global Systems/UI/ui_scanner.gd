extends Node
class_name UI_Scanner

func _ready():
	get_tree().node_added.connect(on_node_added)

func on_node_added(node):
	if node is Button:
		node.pressed.connect(on_button_pressed)

func on_button_pressed():
	AUDIO.play_sfx_once(AUDIO.sfx_library.button_click)
