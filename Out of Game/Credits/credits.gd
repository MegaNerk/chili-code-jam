extends Control
class_name Credits

signal closed_credits

@export var back_button : Button

func close_credits():
	emit_signal("closed_credits")
