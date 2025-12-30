extends Control

func return_to_main_menu():
	STATE.go_to_state(STATE.GAME_STATE.MAIN_MENU)
