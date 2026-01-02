extends Node
class_name CityDirector

var city_res_path : String = "res://In Game/Game Logic/Cities/All Cities/"

var city_library : Array[City_Res]
var active_cities : Array[City]

func _ready():
	load_city_library()

func load_city_library():
	var city_dir : DirAccess = DirAccess.open(city_res_path)
	assert(city_dir, "Could not find City Resource Directory")
	city_dir.list_dir_begin()
	var next_file_name = city_dir.get_next()
	while next_file_name != "":
		if next_file_name.ends_with(".tres"):
			var final_path = city_res_path + "/" + next_file_name
			var this_res = ResourceLoader.load(final_path)
			if this_res is City_Res:
				city_library.append(this_res)
		next_file_name = city_dir.get_next()
	city_dir.list_dir_end()

func activate_cities(num_cities : int):
	city_library.shuffle()
	var iterator : int = 0
	while iterator < num_cities and iterator < city_library.size()-1:
		var next_city = City.new(city_library[iterator])
		next_city.id = iterator
		active_cities.append(next_city)
		iterator += 1

func process_tick(tick_updates : Array[GameEffect]) -> Array[GameEffect]:
	for city in active_cities:
		if city.is_destroyed == false:
			tick_updates = city.process_tick(tick_updates)
	return tick_updates

func get_city_with_id(id : int) -> City:
	return active_cities[id]

func check_on_cities():
	for city in active_cities:
		if city.devastation == 100.0:
			city.get_destroyed()
