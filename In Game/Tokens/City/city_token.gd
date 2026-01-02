extends TokenPin
class_name CityToken

@export var city_name_label : Label

var my_city : City

func _ready():
	super()
	if my_city:
		city_name_label.text = my_city.name
