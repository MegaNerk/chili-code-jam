extends Control
class_name FearStockpile

@export var fear_count_bar : TextureProgressBar
@export var fear_count : Label

func update_score(new_score):
	fear_count_bar.value = new_score
