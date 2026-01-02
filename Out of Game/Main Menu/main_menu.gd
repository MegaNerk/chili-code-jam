extends Control

@export var new_game_button : Button
@export var load_game_button : Button
@export var settings_button : Button
@export var quit_button : Button
@export var credits_menu : Credits

func new_game():
	STATE.go_to_state(STATE.GAME_STATE.IN_GAME)

func settings_pressed():
	SETTINGS.open_settings()

func quit_game():
	get_tree().quit()

func credits_opened():
	credits_menu.visible = true
	AUDIO.music_player.stream = AUDIO.credits_music
	AUDIO.music_player.play()

func on_credits_closed():
	credits_menu.visible = false
	AUDIO.music_player.stream = AUDIO.menu_music_tracks
	AUDIO.music_player.play()
