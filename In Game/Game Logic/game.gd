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

@export var kaiju_cost_scaling : KaijuCostScaling

var ticks_elapsed : int

var next_available_kaiju_id : int = 0
var active_kaiju : Array[Kaiju]
var next_available_building_id : int = 0
var active_buildings : Array[Building]

var kaiju_points : int = 0:
	set(value):
		kaiju_points = min(value, kp_for_next_kaiju)
var food : int = 100
var fear : int = 0:
	set(value):
		fear = min(value, 100)

var gained_kaiju_points : float = 0.0
var gained_food : float = 0.0
var gained_fear : float = 0.0

var fatigue : int = 0:
	set(value):
		fatigue = max(0,min(value,max_fatigue))
var gained_fatigue : float = 0.0
var max_fatigue : int = 100

var kp_for_next_kaiju : int

func _ready():
	load_all_kaiju_resources()
	load_all_building_resources()
	game_ui.prep_compendiums(all_kaiju_res, all_building_res)
	kp_for_next_kaiju = kaiju_cost_scaling.get_next_cost()
	active_kaiju = game_ui.playspace.kaiju_tokens #This line is temporary, remove later
	city_director.activate_cities(6)
	for city in city_director.active_cities:
		print(city.name)
	game_ui.spawn_cities(city_director.active_cities)

func _process(delta):
	var kp_progress : int = int(100.0*(float(kaiju_points)/float(kp_for_next_kaiju)))
	game_ui.update_resource_counts(food,fear,kp_progress)

func change_speed(new_speed):
	time_coordinator.current_speed = new_speed

func date_changed(new_date_string):
	game_ui.update_date_display(new_date_string)

func on_tick_passed():
	ticks_elapsed += 1
	var tick_updates : Array[GameEffect] = []
	for kaiju in active_kaiju:
		kaiju._update_movement()
		tick_updates = kaiju.process_tick(tick_updates)
		
	for building in active_buildings:
		tick_updates = building.process_tick(tick_updates)
	
	tick_updates = city_director.process_tick(tick_updates)
	tick_updates = event_director.process_tick(tick_updates)
	process_tick_updates(tick_updates)

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
	if selected_entry is Kaiju_Res:
		attempt_spawn_kaiju(selected_entry)

func attempt_place_building(building : Building_Res):
	if food >= building.food_cost and fear >= building.fear_cost:
		food -= building.food_cost
		fear -= building.fear_cost
		game_ui.queue_place_building(Building.new(building))
	else: AUDIO.play_sfx_once(AUDIO.sfx_library.illegal_input)

func attempt_spawn_kaiju(new_kaiju : Kaiju_Res):
	if  food >= new_kaiju.food_cost and fear >= new_kaiju.fear_cost and kaiju_points == kp_for_next_kaiju:
		food -= new_kaiju.food_cost
		fear -= new_kaiju.fear_cost
		var the_kaiju = preload("res://In Game/Kaiju/Kaiju_Unit.tscn").instantiate()
		the_kaiju.kaiju_resource = new_kaiju
		game_ui.queue_spawn_kaiju(the_kaiju)
	else: AUDIO.play_sfx_once(AUDIO.sfx_library.illegal_input)

func on_building_placed(building : Building):
	register_building(building)

func on_building_cancelled(building : Building):
	pass

func on_kaiju_spawned(this_kaiju : Kaiju):
	register_kaiju(this_kaiju)
	kaiju_cost_scaling.add_spawned_kaiju()
	kp_for_next_kaiju = kaiju_cost_scaling.get_next_cost()
	kaiju_points = 0

func on_kaiju_cancelled(building : Building):
	pass

func check_for_win_loss():
	var win_state : bool = true
	for city in city_director.active_cities:
		if city.devastation < 100.0:
			win_state = false
			break
	if win_state:
		end_game(true)
	elif fatigue == max_fatigue:
		end_game(false)

func end_game(win : bool):
	pass

func process_tick_updates(tick_updates : Array[GameEffect]):
	for effect in tick_updates:
		resolve_game_effect(effect)
	log_resource_delta()

func resolve_game_effect(effect : GameEffect):
	match effect.type:
		GameEffect.EFFECT_TYPE.RESOURCE_DELTA:
			for resource_type in effect.payload.keys():
				match resource_type:
					"food":
						gained_food += effect.payload["food"]
					"fear":
						gained_fear += effect.payload["fear"]
					"kp":
						gained_kaiju_points += effect.payload["kp"]
		GameEffect.EFFECT_TYPE.KAIJU_HP_DELTA:
			for kaiju_id in effect.payload.keys():
				get_kaiju_with_id(kaiju_id).adjust_hp(effect.payload[kaiju_id])
		GameEffect.EFFECT_TYPE.KAIJU_HUNGER_DELTA:
			for kaiju_id in effect.payload.keys():
				get_kaiju_with_id(kaiju_id).adjust_hunger(effect.payload[kaiju_id])
		GameEffect.EFFECT_TYPE.KILL_KAIJU:
			for kaiju_id in effect.payload.keys():
				get_kaiju_with_id(kaiju_id).die()
		GameEffect.EFFECT_TYPE.CITY_POP_DELTA:
			for city_id in effect.payload.keys():
				city_director.get_city_with_id(city_id).population += effect.payload[city_id]
		GameEffect.EFFECT_TYPE.CITY_DEV_DELTA:
			for city_id in effect.payload.keys():
				city_director.get_city_with_id(city_id).devastation += effect.payload[city_id]

func get_kaiju_with_id(id : int) -> Kaiju:
	for this_kaiju in active_kaiju:
		if this_kaiju.id == id:
			return this_kaiju
	return null

func get_building_with_id(id : int) -> Building:
	for this_building in active_buildings:
		if this_building.id == id:
			return this_building
	return null

func register_building(new_building : Building):
	active_buildings.append(new_building)
	new_building.id = next_available_building_id
	next_available_building_id += 1

func register_kaiju(new_kaiju : Kaiju):
	active_kaiju.append(new_kaiju)
	new_kaiju.id = next_available_kaiju_id
	next_available_kaiju_id += 1

func log_resource_delta():
	while gained_food >= 1.0:
		gained_food -= 1.0
		food += 1
	while gained_fear >= 1.0:
		gained_fear -= 1.0
		fear += 1
	while gained_kaiju_points >= 1.0:
		gained_kaiju_points -= 1.0
		kaiju_points += 1
