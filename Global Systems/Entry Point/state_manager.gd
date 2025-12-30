extends Node

signal state_changed(old_state, new_state)

enum GAME_STATE {
	MAIN_MENU,
	IN_GAME
}

var current_state : GAME_STATE

func go_to_state(new_state : GAME_STATE):
	var old_state = current_state
	current_state = new_state
	match new_state:
		GAME_STATE.MAIN_MENU:
			change_scene("res://Out of Game/Main Menu/main_menu.tscn")
		GAME_STATE.IN_GAME:
			change_scene("res://In Game/Game Logic/game.tscn")
	emit_signal("state_changed",old_state,new_state)

func change_scene(path : String):
	get_tree().change_scene_to_file(path)
