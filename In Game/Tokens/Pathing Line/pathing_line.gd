extends Line2D
class_name PathingLine

var source : Vector2
var target : Vector2

func _process(delta):
	if visible:
		points[0] = source
		points[points.size()-1] = target
