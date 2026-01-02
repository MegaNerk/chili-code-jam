extends Control
class_name KPStockpile

@export var kp_count_bar : TextureProgressBar
@export var progress : Label

func update_progress(new_progress):
	kp_count_bar.value = new_progress
	progress.text = str(new_progress)+"%"
