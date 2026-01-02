extends Control
class_name InGameUI

signal speed_toggled(new_speed)
signal compendium_entry_selected(entry)
signal building_placed(building_ref)
signal building_placement_cancelled(building_ref)
signal kaiju_spawned(kaiju_ref)
signal kaiju_spawning_cancelled(kaiju_ref)

@export var speed_toggle : TabBar

@export var news_reel : Scrolling_Label

@export var playspace : PlaySpace
@export var hovered_country_label : Label
@export var date_display : Label

@export var kaiju_compendium : Compendium
@export var building_compendium : Compendium

@export var mouse_hover_image : MouseHoverImage
@export var compendium_popup : CompendiumPopup

@export var food_stockpile : FoodStockpile
@export var fear_stockpile : FearStockpile
@export var kp_stockpile : KPStockpile
@export var fatigue_stockpile : FatigueBar

@export var invalid_color : Color
@export var valid_color : Color
var valid_spawning : bool = false

var building_being_placed : Building = null
var kaiju_being_spawned : Kaiju = null

var hovered_entry : Unit_Res = null:
	set(value):
		hovered_entry = value
		if hovered_entry:
			activate_compendium_popup(hovered_entry)
		else: deactivate_compendium_popup()

func _ready():
	playspace.hovered_country.connect(change_hovered_country_name)
	playspace._auto_attack_kaiju.connect(auto_attack_city)
	
func _process(delta):
	if compendium_popup.visible:
		compendium_popup.position = get_local_mouse_position()-Vector2(compendium_popup.size.x,0)
	if kaiju_being_spawned:
		valid_spawning = false
		var cur_region = playspace._get_position_nav_region(get_global_mouse_position())
		if cur_region.navigation_layers & kaiju_being_spawned.kaiju_resource.navigation_layers == 0:
			print("INVALID SPAWNING PLACEMENT")
			mouse_hover_image.self_modulate = invalid_color
			
		else:
			print("VALID SPAWNING PLACEMENT")
			mouse_hover_image.self_modulate = valid_color
			valid_spawning = true
			
	if building_being_placed:
		valid_spawning = false
		var cur_region = playspace._get_position_nav_region(get_global_mouse_position())
		if cur_region.navigation_layers & building_being_placed.my_building_res.placable_on_region == 0:
			print("INVALID SPAWNING PLACEMENT")
			mouse_hover_image.self_modulate = invalid_color
			
		else:
			print("VALID SPAWNING PLACEMENT")
			mouse_hover_image.self_modulate = valid_color
			valid_spawning = true

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

func update_resource_counts(food_count, fear_count, kp_progress, fatigue):
	food_stockpile.update_count(food_count)
	fear_stockpile.update_score(fear_count)
	kp_stockpile.update_progress(kp_progress)
	fatigue_stockpile.update_score(fatigue)

func spawn_cities(cities):
	for city in cities:
		playspace.spawn_city(city)

func queue_place_building(building : Building):
	if kaiju_being_spawned:
		cancel_kaiju()
	if building_being_placed:
		cancel_building()
	building_being_placed = building
	mouse_hover_image.visible = true
	mouse_hover_image.texture = building.art

func queue_spawn_kaiju(new_kaiju : Kaiju):
	if building_being_placed:
		cancel_building()
	if kaiju_being_spawned:
		cancel_kaiju()
	kaiju_being_spawned = new_kaiju
	mouse_hover_image.visible = true
	mouse_hover_image.texture = new_kaiju.kaiju_resource.art

func _on_playspace_left_clicked(coords):
	AUDIO.play_sfx_once(AUDIO.sfx_library.click_sound)
	if building_being_placed:
		if valid_spawning:
			place_building(coords)
	if kaiju_being_spawned:
		if valid_spawning:
			spawn_kaiju(coords)
			AUDIO.play_sfx_once(AUDIO.sfx_library.kaiju_roar_1)
		else:
			AUDIO.play_sfx_once(AUDIO.sfx_library.illegal_input)

func _on_playspace_right_clicked(coords):
	if building_being_placed:
		cancel_building()
	if kaiju_being_spawned:
		cancel_kaiju()

func cancel_building():
	emit_signal("building_placement_cancelled", building_being_placed)
	building_being_placed = null
	mouse_hover_image.visible = false

func cancel_kaiju():
	emit_signal("kaiju_spawning_cancelled", kaiju_being_spawned)
	kaiju_being_spawned = null
	mouse_hover_image.visible = false

func place_building(coords):
	emit_signal("building_placed",building_being_placed)
	playspace.spawn_building(building_being_placed, coords)
	building_being_placed = null
	mouse_hover_image.visible = false
	AUDIO.play_sfx_once(AUDIO.sfx_library.building_placement)

func spawn_kaiju(coords):
	emit_signal("kaiju_spawned",kaiju_being_spawned)
	playspace.spawn_kaiju(kaiju_being_spawned, coords)
	kaiju_being_spawned = null
	mouse_hover_image.visible = false

func on_compendium_entry_hovered(entry_ref):
	activate_compendium_popup(entry_ref)

func on_compendium_entry_hover_stopped(entry_ref):
	deactivate_compendium_popup()

func activate_compendium_popup(entry_ref):
	compendium_popup.visible = true
	compendium_popup.tooltip = entry_ref.tooltip

func deactivate_compendium_popup():
	compendium_popup.visible = false

func auto_attack_city(kaiju_ref, city_ref):
	kaiju_ref.begin_attacking_city(city_ref)

func on_city_selected(city_ref):
	var possible_attacker = playspace.selected_kaiju
	if possible_attacker:
		possible_attacker.begin_attacking_city(city_ref)

func queue_news_story(story : String):
	news_reel.queue_text(story)
