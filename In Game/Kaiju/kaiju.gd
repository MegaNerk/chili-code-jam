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
		xp = value
		if xp >= kaiju_resource.xp_per_level:
			level_up()
			var remainder = xp-kaiju_resource.xp_per_level
			xp = remainder
		emit_signal("stats_changed")

var attacking_city : City

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
	nav_agent.target_reached.connect(_on_target_reached)
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
	var current_region = _closest_region_to_position(nav_agent, global_position)
	return current_region

func _closest_region_to_position(agent, target_position) -> NavigationRegion2D:
	var map_rid = NavigationServer2D.agent_get_map(agent.get_rid())
	var region_rid = NavigationServer2D.map_get_closest_point_owner(map_rid, target_position)
	return instance_from_id(NavigationServer2D.region_get_owner_id(region_rid)) as NavigationRegion2D

func _on_link_reached(details):
	print("Kaiju {name} used the {waterway}".format({"name" : name, "waterway" : details.rid}))

func _on_target_reached():
	pass
	
func _on_navigation_finished():
	pass

func _target_location(new_location):
	pass

func process_tick(tick_updates : Array[GameEffect]) -> Array[GameEffect]:
	if attacking_city:
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

func begin_attacking_city(city : City):
	if attacking_city:
		stop_attacking_city()
	attacking_city = city
	attacking_city.being_attacked_by_kaiju.append(self)
	AUDIO.play_sfx_once(AUDIO.sfx_library.country_hover)

func stop_attacking_city():
	attacking_city.being_attacked_by_kaiju.erase(self)
	attacking_city = null

func die():
	if attacking_city:
		stop_attacking_city()
	emit_signal("died")

func adjust_xp(adjustment : float):
	xp += adjustment

func level_up():
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
