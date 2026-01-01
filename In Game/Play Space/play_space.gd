extends Control

@export var pathing_line_scene : PackedScene

@export var world_map : Control
@export var kaiju_tokens : Array[KaijuToken]
var selected_kaiju: KaijuToken

var region_map : WorldMap

signal hovered_country(country_name)

func _ready():
	region_map = world_map.find_child("WorldMap")
	region_map.hovered_region_changed.connect(hovered_region)
	for kaiju in kaiju_tokens:
		kaiju.left_clicked.connect(select_kaiju.bind(kaiju))
		kaiju.right_clicked.connect(deselect_all_kaiju)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if selected_kaiju:
				print("ORDER TO MOVE NOW")


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
