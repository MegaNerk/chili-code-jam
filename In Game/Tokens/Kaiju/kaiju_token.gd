extends TokenPin
class_name KaijuToken

var my_kaiju : Kaiju

@export var health_bar : ProgressBar
@export var health_label : Label
@export var hunger_bar : ProgressBar

func _ready():
	super()
	default_draw_prio = 1

func _load_kaiju(_kaiju):
	my_kaiju = _kaiju
	_change_image(my_kaiju.kaiju_resource.art)
	sync_kaiju_stats()
	my_kaiju.stats_changed.connect(sync_kaiju_stats)
	
func _change_image(new_img):
	$PanelContainer/TextureRect.texture = new_img

func sync_kaiju_stats():
	health_bar.max_value = my_kaiju.base_hp
	health_bar.value = my_kaiju.hp
	health_label.text = str(my_kaiju.hp)+"/"+str(my_kaiju.base_hp)
	hunger_bar.value = my_kaiju.hunger
	hunger_bar.max_value = my_kaiju.max_hunger
