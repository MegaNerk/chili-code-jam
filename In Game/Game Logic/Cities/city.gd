extends RefCounted
class_name City

signal stats_changed

var my_city_res : City_Res

var name : String = "City Name"
var devastation : int = 0:
	set(value):
		devastation = value
		emit_signal("stats_changed")

var base_pop : float = 0.0 #In millions
var population : float = 0.0: #In millions
	set(value):
		population = value
		emit_signal("stats_changed")

var coordinates : Vector2 = Vector2(0.0,0.0)
var country : String = "None"
var art : Texture2D = null

func _init(city_res : City_Res):
	if city_res:
		my_city_res = city_res
		name = city_res.name
		base_pop = city_res.population
		population = city_res.population
		coordinates = city_res.coordinates
		country = city_res.country
		art = city_res.art
