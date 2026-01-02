extends Control
class_name PlaySpace

@export var pathing_line_scene : PackedScene

@export var world_map : WorldMap
@export var kaiju_tokens : Array[Kaiju]
@export var nav_region : NavigationRegion2D
var selected_kaiju: Kaiju

signal hovered_country(country_name)
signal update_kaiju_location(delta, speed)

signal kaiju_target_position(kaiju, target_position)
signal left_clicked(event_position)
signal right_clicked(event_position)


func _ready():
	world_map.hovered_region_changed.connect(hovered_region)
	for kaiju in kaiju_tokens:
		kaiju.token.left_clicked.connect(select_kaiju.bind(kaiju))
		kaiju.token.right_clicked.connect(deselect_all_kaiju)

func _update_playspace(delta, speed):
	_update_kaiju_locations(delta, speed)
	
func _update_kaiju_locations(delta, speed):
	for kaiju in kaiju_tokens:
		kaiju._update_speed()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				_on_right_click(get_global_mouse_position())
			if event.button_index == MOUSE_BUTTON_LEFT:
				_on_left_click(get_global_mouse_position())
				
func _on_left_click(_pos):
	left_clicked.emit(_pos)

func _on_right_click(_pos):
	right_clicked.emit(_pos)
	if selected_kaiju:
		var valid_position = selected_kaiju._closest_nav_position(_pos)
		selected_kaiju.nav_agent.target_position = valid_position
		kaiju_target_position.emit(selected_kaiju,valid_position)


#func _gui_input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			##TODO: Improve Logic 
			#if selected_kaiju:
				#print("ORDER {name} TO MOVE NOW".format({"name" : selected_kaiju.name}))
				#print(selected_kaiju.global_position)
				#print(get_global_mouse_position())
				#selected_kaiju.nav_agent.target_position = get_global_mouse_position()
				#
func hovered_region(region, country_name):
	emit_signal("hovered_country", country_name)

func deselect_all_kaiju():
	print("Clearing Kaiju Selection")
	if selected_kaiju:
		selected_kaiju.token.get_unselected()
		selected_kaiju = null

func select_kaiju(kaiju_refence : Kaiju):
	if kaiju_refence == selected_kaiju:
		print("Same as Selected", kaiju_refence, selected_kaiju)
	else:
		deselect_all_kaiju()
		print("Now Selecting", kaiju_refence)
		selected_kaiju = kaiju_refence
		selected_kaiju.token.get_selected()
		
func spawn_city(city : City):
	var token = preload("res://In Game/Tokens/City/city_token.tscn")
	var new_city = token.instantiate()
	new_city.my_city = city
	add_child(new_city)
	new_city.position = city.coordinates
	
func spawn_kaiju(kaiju : Kaiju_Res, pos):
	var kaiju_unit = preload("res://In Game/Kaiju/Kaiju_Unit.tscn")
	var new_kaiju = kaiju_unit.instantiate()
	new_kaiju.kaiju_resource = Kaiju_Res
	new_kaiju.position = pos
	nav_region.add_child(new_kaiju)
