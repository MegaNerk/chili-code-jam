extends Control
class_name InGameUI

signal speed_toggled(new_speed)
signal compendium_entry_selected(entry)
signal building_placed(building_ref)
signal building_placement_cancelled(building_ref)

@export var speed_toggle : TabBar

@export var playspace : PlaySpace
@export var hovered_country_label : Label
@export var date_display : Label

@export var kaiju_compendium : Compendium
@export var building_compendium : Compendium

@export var mouse_hover_image : MouseHoverImage

@export var food_stockpile : FoodStockpile
@export var fear_stockpile : FearStockpile

var building_being_placed : Building = null

func _ready():
	playspace.hovered_country.connect(change_hovered_country_name)
	
func _on_game_tick(delta, speed):
	playspace._update_playspace(delta, speed)
	
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

func on_compendium_entry_selected(selected_entry):
	emit_signal("compendium_entry_selected", selected_entry)

func prep_compendiums(kaiju_resources : Array[Kaiju_Res], building_resources : Array[Building_Res]):
	kaiju_compendium.load_multiple_entries(kaiju_resources)
	building_compendium.load_multiple_entries(building_resources)

func update_resource_counts(food_count, fear_count):
	food_stockpile.update_count(food_count)
	fear_stockpile.update_score(fear_count)

func spawn_cities(cities):
	for city in cities:
		playspace.spawn_city(city)

func queue_place_building(building : Building):
	building_being_placed = building
	mouse_hover_image.visible = true
	mouse_hover_image.texture = building.art

func _on_playspace_left_clicked(coords):
	if building_being_placed:
		emit_signal("building_placed",building_being_placed)
		playspace.spawn_building(building_being_placed, coords)
		building_being_placed = null
		mouse_hover_image.visible = false

func _on_playspace_right_clicked(coords):
	if building_being_placed:
		building_being_placed = null
		mouse_hover_image.visible = false
		emit_signal("building_placement_cancelled")
