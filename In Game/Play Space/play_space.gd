extends Control
class_name PlaySpace

@export var pathing_line_scene : PackedScene

@export var world_map : WorldMap
@export var kaiju_tokens : Array[KaijuToken]
@export var nav_region : NavigationRegion2D
var selected_kaiju: KaijuToken

signal hovered_country(country_name)
signal update_kaiju_location(delta, speed)

func _ready():
	world_map.hovered_region_changed.connect(hovered_region)
	for kaiju in kaiju_tokens:
		kaiju.left_clicked.connect(select_kaiju.bind(kaiju))
		kaiju.right_clicked.connect(deselect_all_kaiju)

func _update_playspace(delta, speed):
	_update_kaiju_locations(delta, speed)
	
func _update_kaiju_locations(delta, speed):
	for kaiju in kaiju_tokens:
		kaiju._update_location()


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if selected_kaiju:
				print("ORDER {name} TO MOVE NOW".format({"name" : selected_kaiju.name}))
				print(selected_kaiju.global_position)
				print(get_global_mouse_position())
				selected_kaiju.nav_agent.target_position = get_global_mouse_position()

func hovered_region(region, country_name):
	emit_signal("hovered_country", country_name)

func deselect_all_kaiju():
	print("Clearing Kaiju Selection")
	if selected_kaiju:
		selected_kaiju.get_unselected()
		selected_kaiju = null

func select_kaiju(kaiju_refence : KaijuToken):
	if kaiju_refence == selected_kaiju:
		print("Same as Selected", kaiju_refence, selected_kaiju)
	else:
		deselect_all_kaiju()
		print("Now Selecting", kaiju_refence)
		selected_kaiju = kaiju_refence
		selected_kaiju.get_selected()
