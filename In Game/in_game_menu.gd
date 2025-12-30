extends Control

func settings_pressed():
	SETTINGS.open_settings()

func return_to_main_menu():
	STATE.go_to_state(STATE.GAME_STATE.MAIN_MENU)
