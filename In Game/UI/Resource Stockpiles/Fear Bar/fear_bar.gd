extends Control
class_name FearStockpile

@export var fear_count_bar : TextureProgressBar
@export var fear_count : Label

var fear_score : int = 0

func update_score(new_score):
	fear_score = new_score
	fear_count_bar.value = new_score
	fear_count.text = str(fear_score)+"/100"
