extends Control
class_name InGameUI

signal speed_toggled(new_speed)

@export var speed_toggle : TabBar

@export var playspace : Control
@export var hovered_country_label : Label
@export var date_display : Label

func _ready():
	playspace.hovered_country.connect(change_hovered_country_name)
	
func change_hovered_country_name(country_name : String):
	hovered_country_label.text = country_name
	AUDIO.play_sfx_once(AUDIO.sfx_library.country_hover)

func on_speed_toggled(new_speed):
	emit_signal("speed_toggled", new_speed)
	
func settings_pressed():
	SETTINGS.open_settings()

func return_to_main_menu():
	STATE.go_to_state(STATE.GAME_STATE.MAIN_MENU)

func update_date_display(new_date : String):
	date_display.text = new_date
