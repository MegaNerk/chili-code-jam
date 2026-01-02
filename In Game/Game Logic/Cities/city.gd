extends RefCounted
class_name City

signal stats_changed
signal destroyed

var my_city_res : City_Res

var name : String = "City Name"
var devastation : float = 0.0:
	set(value):
		var delta = value - devastation
		delta = modify_devastation_adjustment(delta)
		devastation = max(0.0,min(devastation+delta,100.0))
		emit_signal("stats_changed")

var base_pop : float = 0.0 #In millions
var population : float = 0.0: #In millions
	set(value):
		population = max(0,min(value,base_pop))
		emit_signal("stats_changed")

var my_token : CityToken
var coordinates : Vector2 = Vector2(0.0,0.0)
var country : String = "None"
var art : Texture2D = null

var id : int #Unique ID given to active cities by City Director


var being_attacked_by_kaiju : Array[Kaiju] = []
var is_destroyed : bool = false

func _init(city_res : City_Res):
	if city_res:
		my_city_res = city_res
		name = city_res.name
		base_pop = city_res.population
		population = city_res.population
		coordinates = city_res.coordinates
		country = city_res.country
		art = city_res.art

func is_in_range_of_kaiju(kaiju_ref) -> bool:
	var distance_from_kaiju = PlaySpace._get_global_distance(kaiju_ref, self)
	if distance_from_kaiju <= my_city_res.defense_distance: 
		return true
	return false

func process_tick(tick_updates):
	if being_attacked_by_kaiju.size() > 0:
		
		var new_effect = GameEffect.new()
		new_effect.type = GameEffect.EFFECT_TYPE.KAIJU_HP_DELTA
		new_effect.payload = {}
		
		for attacking_kaiju in being_attacked_by_kaiju:
			if is_in_range_of_kaiju(attacking_kaiju):
				var damage : float = randf_range(-0.1, -0.01)
				new_effect.payload[attacking_kaiju.id] = damage

			
		tick_updates.append(new_effect)
	else:
		var fatigue_effect = GameEffect.new()
		fatigue_effect.type = GameEffect.EFFECT_TYPE.RESOURCE_DELTA
		var fatigue_gain = randf_range(0.00001, 0.0001)
		fatigue_gain *= (population/base_pop)
		fatigue_effect.payload = {
			"fatigue" : fatigue_gain
		}
		tick_updates.append(fatigue_effect)
		var new_effect = GameEffect.new()
		new_effect.type = GameEffect.EFFECT_TYPE.CITY_POP_DELTA
		var pop_growth = randf_range(0.0001, 0.0004)
		new_effect.payload = {
			id : pop_growth
		}
		tick_updates.append(new_effect)
		var dev_effect = GameEffect.new()
		dev_effect.type = GameEffect.EFFECT_TYPE.CITY_DEV_DELTA
		var dev_repair = randf_range(-0.1, -0.001)
		dev_effect.payload = {
			id : dev_repair
		}
		tick_updates.append(dev_effect)
	return tick_updates

func get_destroyed():
	population = 0.0
	is_destroyed = true
	emit_signal("destroyed")

func modify_devastation_adjustment(adjustment : float) -> float:
	if adjustment > 0.0:
		adjustment *= (1.0+(base_pop-population)/base_pop)
	elif adjustment < 0.0:
		adjustment /= (1.0+(base_pop-population)/base_pop)
	return adjustment
