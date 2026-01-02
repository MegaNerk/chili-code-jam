extends Node
class_name NewsReporter

signal news_story_queued(news_story)

var news_res_path : String = "res://In Game/Game Logic/News/All News Stories/"

var previous_stories : Array[News_Res] = []
var ready_stories : Array[News_Res] = []
var waiting_stories : Array[News_Res] = []

func _ready():
	load_news_library()

func process_tick(tick_update):
	if ready_stories.size() > 0 and randi_range(1,1001) > 999:
		queue_new_news_clip()

func queue_new_news_clip():
	var some_stories = ready_stories.duplicate()
	some_stories.shuffle()
	var this_story = some_stories[0]
	ready_stories.erase(this_story)
	previous_stories.append(this_story)
	var temp : Array = []
	for other_story in waiting_stories:
		if other_story.previous_story == this_story:
			ready_stories.append(other_story)
			temp.append(other_story)
	for other_story in temp:
		waiting_stories.erase(other_story)
	emit_signal("news_story_queued", this_story)

func load_news_library():
	var news_dir : DirAccess = DirAccess.open(news_res_path)
	assert(news_dir, "Could not find News Resource Directory")
	news_dir.list_dir_begin()
	var next_file_name = news_dir.get_next()
	while next_file_name != "":
		if next_file_name.ends_with(".tres"):
			var final_path = news_res_path + "/" + next_file_name
			var this_res = ResourceLoader.load(final_path)
			if this_res is News_Res:
				if this_res.previous_story:
					waiting_stories.append(this_res)
				ready_stories.append(this_res)
		next_file_name = news_dir.get_next()
	news_dir.list_dir_end()
