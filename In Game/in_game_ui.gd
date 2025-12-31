extends Control

@export var playspace : Control
@export var hovered_country_label : Label

func _ready():
	playspace.hovered_country.connect(change_hovered_country_name)
	
func change_hovered_country_name(country_name : String):
	hovered_country_label.text = country_name
	AUDIO.play_sfx_once(AUDIO.sfx_library.country_hover)
	
func settings_pressed():
	SETTINGS.open_settings()

func return_to_main_menu():
	STATE.go_to_state(STATE.GAME_STATE.MAIN_MENU)
