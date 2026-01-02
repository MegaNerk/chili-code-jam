extends CharacterBody2D
class_name Kaiju

signal changed_region
signal stats_changed
signal leveled_up
signal died

@export var kaiju_resource : Kaiju_Res

@onready var token : KaijuToken = $KaijuToken
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
var local_speed : int = 100
var current_region : NavigationRegion2D

var paid_for_with_discount : bool = false

var id : int #A unique id handed to this Kaiju when it's registered with the Game manager
var base_hp : float
var hp : float:
	set(value):
		hp = max(0,min(value,base_hp))
		emit_signal("stats_changed")
var max_hunger : float
var hunger : float:
	set(value):
		hunger = max(0,min(value,max_hunger))
		emit_signal("stats_changed")
var land_speed : float
var water_speed : float
var city_damage : float
var pop_damage : float

var level : int = 1
var xp : float = 0.0:
	set(value):
		if level < kaiju_resource.max_level:
			xp = value
			if xp >= kaiju_resource.xp_per_level:
				level_up()
				var remainder = xp-kaiju_resource.xp_per_level
				if level < kaiju_resource.max_level:
					xp = remainder
				else: xp = 0.0
		else:
			xp = 0.0
		emit_signal("stats_changed")

var attacking_city : City
var attack_buffer : float = 6
var movement_distance = 3

func _ready():
	if kaiju_resource:
		name = kaiju_resource.name
		base_hp = kaiju_resource.base_hp
		hp = kaiju_resource.base_hp
		max_hunger = kaiju_resource.max_hunger
		hunger = kaiju_resource.max_hunger
		land_speed = kaiju_resource.land_speed
		water_speed = kaiju_resource.water_speed
		city_damage = kaiju_resource.city_damage
		pop_damage = kaiju_resource.pop_damage
	
	nav_agent.link_reached.connect(_on_link_reached)
	
	
	hp -= 20.0

func _update_movement():
	_update_region()
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	if nav_agent.is_target_reachable():
		var next_point = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_point)
		velocity = direction * local_speed
	move_and_slide()

func _update_region():
	var region = _get_current_region()
	if current_region == region:
		return
		
	current_region = region
	changed_region.emit()
	
	match current_region.navigation_layers:
		1:
			local_speed = kaiju_resource.water_speed
		2:
			local_speed = kaiju_resource.land_speed

func _closest_nav_position(target_position) -> Vector2:
	var map_rid = NavigationServer2D.agent_get_map(nav_agent.get_rid())
	var nearest_pos = NavigationServer2D.map_get_closest_point(map_rid, target_position)
	return nearest_pos

func _get_current_region() -> NavigationRegion2D:
	var current_region = PlaySpace._closest_agent_region_to_position(nav_agent, global_position)
	return current_region


func _on_link_reached(details):
	print("Kaiju {name} used the {waterway}".format({"name" : name, "waterway" : details.rid}))

func _target_radius(loc, rad, callback):
	pass

func _target_location(new_location, distance, callback : Callable):
	_clear_order()
	var valid_position = _closest_nav_position(new_location)
	nav_agent.target_position = valid_position
	nav_agent.target_desired_distance = distance
	if callback:
		nav_agent.target_reached.connect(callback)
	
	

func is_in_range_of_city(city_ref) -> bool:
	var distance_from_city = PlaySpace._get_global_distance(self, city_ref)
	if distance_from_city <= kaiju_resource.attack_range: 
		return true
	return false

func process_tick(tick_updates : Array[GameEffect]) -> Array[GameEffect]:
	if attacking_city:
		if is_in_range_of_city(attacking_city):
			tick_updates.append_array(fight_city_tick_updates())
	elif hunger > 0.0:
		var heal_effect = GameEffect.new()
		heal_effect.type = GameEffect.EFFECT_TYPE.KAIJU_HP_DELTA
		var hp_gain = 0.02
		heal_effect.payload = {
			id : hp_gain
		}
		tick_updates.append(heal_effect)
		var hunger_effect = GameEffect.new()
		hunger_effect.type = GameEffect.EFFECT_TYPE.KAIJU_HUNGER_DELTA
		hunger_effect.payload = {
			id : -0.1,
		}
		tick_updates.append(hunger_effect)
	else:
		var hunger_effect = GameEffect.new()
		hunger_effect.type = GameEffect.EFFECT_TYPE.KAIJU_HP_DELTA
		hunger_effect.payload = {
			id : -0.1,
		}
		tick_updates.append(hunger_effect)
	return tick_updates

func adjust_hp(adjustment : float):
	hp = max(0,min(hp+adjustment,base_hp))

func adjust_hunger(adjustment : float):
	hunger = max(0,min(hunger+adjustment,max_hunger))

func _clear_order():
	if nav_agent.target_reached.is_connected(enter_city_radius):
		nav_agent.target_reached.disconnect(enter_city_radius)

func enter_city_radius():
	_clear_order()

func begin_attacking_city(city : City):
	if attacking_city:
		AUDIO.play_sfx_once(AUDIO.sfx_library.city_destruction)
		stop_attacking_city()
	else:
		print("Try to attack : ", city)
		if not is_in_range_of_city(city):
			var city_pos = city.my_token.global_position + (city.my_token.pivot_offset * city.my_token.scale)
			
			_target_location(city_pos, kaiju_resource.attack_range / 2, enter_city_radius)
		attacking_city = city
		attacking_city.being_attacked_by_kaiju.append(self)
		AUDIO.play_sfx_once(AUDIO.sfx_library.country_hover)

func stop_attacking_city():
	attacking_city.being_attacked_by_kaiju.erase(self)
	attacking_city = null

func die():
	AUDIO.play_sfx_once(AUDIO.sfx_library.kaiju_death)
	if attacking_city:
		stop_attacking_city()
	emit_signal("died")

func adjust_xp(adjustment : float):
	xp += adjustment

func level_up():
	AUDIO.play_sfx_once(AUDIO.sfx_library.Levelup)
	if level < 15:
		level += 1
		base_hp += kaiju_resource.hp_scaling
		hp += kaiju_resource.hp_scaling
		max_hunger += kaiju_resource.hunger_scaling
		hunger += kaiju_resource.hunger_scaling
		land_speed += kaiju_resource.land_speed_scaling
		water_speed += kaiju_resource.water_speed_scaling
		emit_signal("stats_changed")
		emit_signal("leveled_up")

func fight_city_tick_updates() -> Array[GameEffect]:
	var tick_updates : Array[GameEffect] = []
	var pop_effect = GameEffect.new()
	pop_effect.type = GameEffect.EFFECT_TYPE.CITY_POP_DELTA
	pop_effect.payload = {
		attacking_city.id : pop_damage,
	}
	tick_updates.append(pop_effect)
	var dev_effect = GameEffect.new()
	dev_effect.type = GameEffect.EFFECT_TYPE.CITY_DEV_DELTA
	dev_effect.payload = {
		attacking_city.id : city_damage
	}
	tick_updates.append(dev_effect)
	var xp_effect = GameEffect.new()
	xp_effect.type = GameEffect.EFFECT_TYPE.KAIJU_XP_DELTA
	var xp_gain = 5.1
	xp_effect.payload = {
		id : xp_gain
	}
	tick_updates.append(xp_effect)
	var feed_effect = GameEffect.new()
	feed_effect.type = GameEffect.EFFECT_TYPE.KAIJU_HUNGER_DELTA
	var hunger_gain = 0.25
	feed_effect.payload = {
		id : hunger_gain
	}
	tick_updates.append(feed_effect)
	return tick_updates
