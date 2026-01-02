extends RefCounted
class_name City

var my_city_res : City_Res

var name : String = "City Name"
var devastation : int = 0
var population : float = 0.0 #In millions
var coordinates : Vector2 = Vector2(0.0,0.0)
var country : String = "None"
var art : Texture2D = null

func _init(city_res : City_Res):
	if city_res:
		my_city_res = city_res
		name = city_res.name
		population = city_res.population
		coordinates = city_res.coordinates
		country = city_res.country
		art = city_res.art
