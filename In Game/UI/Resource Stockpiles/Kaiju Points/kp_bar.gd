extends Control
class_name KPStockpile

@export var kp_count_bar : ProgressBar

func update_progress(new_progress):
	kp_count_bar.value = new_progress
