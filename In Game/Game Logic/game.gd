extends Control
class_name Game

var kaiju_res_path : String = "res://In Game/Kaiju/All Kaiju/"
var buildings_res_path : String = "res://In Game/Buildings/All Buildings/"

var all_kaiju_res : Array[Kaiju_Res] = []
var all_building_res : Array[Building_Res] = []

@export var game_ui : InGameUI
@export var event_director : EventDirector
@export var city_director : CityDirector
@export var time_coordinator : TimeCoordinator
@export var news_reporter : NewsReporter

var ticks_elapsed : int

var active_kaiju : Array[Kaiju]
var active_buildings : Array[Building]

var food : int
var fear : int:
	set(value):
		fear = min(value, 100)

func _ready():
	load_all_kaiju_resources()
	load_all_building_resources()
	game_ui.prep_compendiums(all_kaiju_res, all_building_res)
	active_kaiju = game_ui.playspace.kaiju_tokens #This line is temporary, remove later
	city_director.activate_cities(6)
	for city in city_director.active_cities:
		print(city.name)
	game_ui.spawn_cities(city_director.active_cities)

func _process(delta):
	game_ui.update_resource_counts(food,fear)

func change_speed(new_speed):
	time_coordinator.current_speed = new_speed

func date_changed(new_date_string):
	game_ui.update_date_display(new_date_string)

func on_tick_passed():
	ticks_elapsed += 1
	food += 1
	for kaiju in active_kaiju:
		kaiju._update_movement()
		
	for building in active_buildings:
		pass

func load_all_kaiju_resources():
	var kaiju_dir : DirAccess = DirAccess.open(kaiju_res_path)
	assert(kaiju_dir, "Could not find Kaiju Resource Directory")
	kaiju_dir.list_dir_begin()
	var next_file_name = kaiju_dir.get_next()
	while next_file_name != "":
		if next_file_name.ends_with(".tres"):
			var final_path = kaiju_res_path + "/" + next_file_name
			var this_res = ResourceLoader.load(final_path)
			if this_res is Kaiju_Res:
				all_kaiju_res.append(this_res)
		next_file_name = kaiju_dir.get_next()
	kaiju_dir.list_dir_end()

func load_all_building_resources():
	var building_dir : DirAccess = DirAccess.open(buildings_res_path)
	assert(building_dir, "Could not find Building Resource Directory")
	building_dir.list_dir_begin()
	var next_file_name = building_dir.get_next()
	while next_file_name != "":
		if next_file_name.ends_with(".tres"):
			var final_path = buildings_res_path + "/" + next_file_name
			var this_res = ResourceLoader.load(final_path)
			if this_res is Building_Res:
				all_building_res.append(this_res)
		next_file_name = building_dir.get_next()
	building_dir.list_dir_end()

func on_compendium_entry_selected(selected_entry):
	if selected_entry is Building_Res:
		attempt_place_building(selected_entry)

func attempt_place_building(building : Building_Res):
	if food >= building.food_cost and fear >= building.fear_cost:
		food -= building.food_cost
		fear -= building.fear_cost
		game_ui.queue_place_building(Building.new(building))
	else: AUDIO.play_sfx_once(AUDIO.sfx_library.illegal_input)

func on_building_placed(building : Building):
	active_buildings.append(building)

func on_building_cancelled(building : Building):
	food += building.my_building_res.food_cost
	fear += building.my_building_res.fear_cost
