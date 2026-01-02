extends Control
class_name FatigueBar

@export var fatigue_bar : ProgressBar

func update_score(new_score):
	fatigue_bar.value = new_score
