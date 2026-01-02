extends TokenPin
class_name CityToken

@export var city_name_label : Label

@export var pop_bar : ProgressBar
@export var devastation_bar : ProgressBar
@export var pop_label : Label
@export var devastation_label : Label

var my_city : City
var label_size_x : float = 252.0

func _ready():
	super()
	if my_city:
		city_name_label.text = my_city.name
		fit_text()
		sync_city_stats()
		my_city.stats_changed.connect(sync_city_stats)

func fit_text():
	var label_font = city_name_label.get_theme_font("font")
	var font_size : int = city_name_label.get_theme_font_size("font_size") + 8
	
	while label_font.get_string_size(city_name_label.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x > (label_size_x-10):
		font_size -= 1
	
	city_name_label.add_theme_font_size_override("font_size", font_size)

func sync_city_stats():
	pop_bar.value = my_city.population
	pop_bar.max_value = my_city.base_pop
	pop_label.text = str(my_city.population).substr(0,3)+"m"
	devastation_bar.value = my_city.devastation
	devastation_label.text = str(my_city.devastation).substr(0,3)+"%"
