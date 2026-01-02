extends CharacterBody2D
class_name Kaiju

signal changed_region
signal stats_changed

@export var kaiju_resource : Kaiju_Res

@onready var token : KaijuToken = $KaijuToken
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
var local_speed : int = 100
var current_region : NavigationRegion2D

var id : int #A unique id handed to this Kaiju when it's registered with the Game manager
var base_hp : int
var hp : int:
	set(value):
		hp = max(0,min(value,base_hp))
		emit_signal("stats_changed")
var max_hunger : int
var hunger : int:
	set(value):
		hunger = max(0,min(value,max_hunger))
		emit_signal("stats_changed")
var land_speed : float
var water_speed : float

var attacking_city : City

func _ready():
	if kaiju_resource:
		name = kaiju_resource.name
		base_hp = kaiju_resource.base_hp
		hp = base_hp
		max_hunger = max_hunger
		hunger = max_hunger
		land_speed = kaiju_resource.land_speed
		water_speed = kaiju_resource.water_speed
	
	nav_agent.link_reached.connect(_on_link_reached)
	nav_agent.target_reached.connect(_on_target_reached)

func _update_movement():
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
		var pop_damage : float = randf_range(-0.002,-0.001)
		pop_effect.payload = {
			attacking_city.id : pop_damage,
		}
		tick_updates.append(pop_effect)
		var dev_effect = GameEffect.new()
		dev_effect.type = GameEffect.EFFECT_TYPE.CITY_DEV_DELTA
		var dev_damage = randf_range(0.0001, 0.001)
		dev_effect.payload = {
			attacking_city.id : dev_damage
		}
		tick_updates.append(dev_effect)
	return tick_updates

func adjust_hp(adjustment : int):
	hp = max(0,min(hp+adjustment,base_hp))

func adjust_hunger(adjustment : int):
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
	print("I died :(")
