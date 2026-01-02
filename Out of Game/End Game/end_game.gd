extends Control
class_name EndGame

@export var win_showcase : TextureRect
@export var loss_showcase : TextureRect

var win_graphic = preload("res://Assets/Art/Win State/WinningScene.png")
var loss_graphic = preload("res://Assets/Art/Win State/LossScene.png")

func activate_end_game(did_win : bool):
		win_showcase.visible = did_win
		loss_showcase.visible = !did_win
