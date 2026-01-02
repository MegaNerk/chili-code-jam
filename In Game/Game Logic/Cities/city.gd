extends RefCounted
class_name City

var my_city_res : City_Res

var name : String = "City Name"
var devastation : int = 0
var population : int = 1
var coordinates : Vector2 = Vector2(0.0,0.0)
var country : String = "None"
var art : Texture2D = null

func _init():
	if my_city_res:
		name = my_city_res.name
		population = my_city_res.population
		coordinates = my_city_res.coordinates
		country = my_city_res.country
		art = my_city_res.art
