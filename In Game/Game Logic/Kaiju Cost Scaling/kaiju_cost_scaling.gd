extends Resource
class_name KaijuCostScaling

@export var set_kp_costs : Array[int]
var spawned_kaiju : int = 0
var last_cost : int = 0

func get_next_cost():
	var next_cost : int = 0
	if spawned_kaiju <= set_kp_costs.size()-1:
		next_cost = set_kp_costs[spawned_kaiju]
	else:
		next_cost = int(last_cost*1.5)
	last_cost = next_cost
	return next_cost

func add_spawned_kaiju():
	spawned_kaiju += 1
