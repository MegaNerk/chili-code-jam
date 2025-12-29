extends Control
class_name Scrolling_Label

@export var my_label : Label
var scroll_speed_cycle_time : float = 100.0

var loop_enabled : bool = true
var cur_loop_index : int = 0
var queued_texts : Array[String] = ["Scrolling text goes here"]

var my_text : String = "Scrolling text goes here":
	set(value):
		my_text = value
		text_changed()

func _ready():
	queue_text("This is the first queued text")
	queue_text("And this is number two")

func _process(delta):
	if my_label.size.x == 0:
		return
	my_label.position.x -= scroll_speed_cycle_time * delta
	if (my_label.position.x + my_label.size.x) < 0:
		my_label.position.x = self.size.x
		cycle_text()

func text_changed():
	my_label.text = ""
	my_label.size.x = 0
	my_label.text = my_text

func queue_text(new_text : String):
	queued_texts.append(new_text)

func cycle_text():
	if !loop_enabled:
		queued_texts.remove_at(cur_loop_index)
		if queued_texts.size() == 0:
			my_text = ""
		else:
			while cur_loop_index > queued_texts.size()-1:
				cur_loop_index += 1
				if cur_loop_index > queued_texts.size()-1:
					cur_loop_index = 0
			my_text = queued_texts[cur_loop_index]
	else:
		cur_loop_index += 1
		if cur_loop_index > queued_texts.size()-1:
			cur_loop_index = 0
		my_text = queued_texts[cur_loop_index]
