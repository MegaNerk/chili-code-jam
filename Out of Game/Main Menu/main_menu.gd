extends Control

@export var new_game_button : Button
@export var load_game_button : Button
@export var settings_button : Button
@export var quit_button : Button

func new_game():
	STATE.go_to_state(STATE.GAME_STATE.IN_GAME)

func quit_game():
	get_tree().quit()
