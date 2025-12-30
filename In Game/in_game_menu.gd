extends Control

@export var _world_map : Control
var world_map

func _ready():
	#I know this is disgusting and will fix later - psy
	world_map = _world_map.find_child("WorldMap") as WorldMap
	world_map.hovered_region_changed.connect(change_hovered_country_name)
	
func change_hovered_country_name(region, country_name : String):
	$VBoxContainer/HBoxContainer2/WorldMap/HoveredContryBox/HoveredContry.text = country_name
	AUDIO.play_sfx_once(AUDIO.sfx_library.country_hover)
	

func settings_pressed():
	SETTINGS.open_settings()

func return_to_main_menu():
	STATE.go_to_state(STATE.GAME_STATE.MAIN_MENU)
