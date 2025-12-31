extends Control

@export var world_map : Control
var region_map : WorldMap

signal hovered_country(country_name)

func _ready():
	region_map = world_map.find_child("WorldMap")
	region_map.hovered_region_changed.connect(hovered_region)

func hovered_region(region, country_name):
	emit_signal("hovered_country", country_name)
