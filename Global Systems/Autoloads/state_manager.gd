extends Node
enum GAME_STATE {
	MAIN_MENU,
	IN_GAME
}

var current_state : GAME_STATE

func go_to_state(new_state : GAME_STATE):
	match new_state:
		GAME_STATE.MAIN_MENU:
			change_scene("res://Out of Game/Main Menu/main_menu.tscn")
		GAME_STATE.IN_GAME:
			change_scene("res://In Game/in_game_menu.tscn")

func change_scene(path : String):
	get_tree().change_scene_to_file(path)
