extends Control
class_name InGameUI

signal speed_toggled(new_speed)

@export var speed_toggle : TabBar

@export var playspace : Control
@export var hovered_country_label : Label
@export var date_display : Label

@export var kaiju_compendium : Compendium
@export var building_compendium : Compendium

@export var mouse_hover_image : MouseHoverImage

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

func on_kaiju_button_pressed():
	kaiju_compendium.visible = !kaiju_compendium.visible

func on_buildings_button_pressed():
	building_compendium.visible = !building_compendium.visible

func on_compendium_entry_selected(selected_entry : Unit_Res):
	mouse_hover_image.visible = true
	mouse_hover_image.texture = selected_entry.art
