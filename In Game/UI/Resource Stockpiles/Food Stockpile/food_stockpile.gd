extends Control
class_name FoodStockpile

@export var count_label : Label

var food_count : int = 0

func update_count(new_count):
	food_count = new_count
	count_label.text = str(food_count)
