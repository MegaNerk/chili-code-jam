extends TokenPin
class_name KaijuToken

var my_kaiju : Kaiju

@export var health_bar : ProgressBar
@export var health_label : Label
@export var hunger_bar : ProgressBar
@export var xp_bar : ProgressBar
@export var level_label : Label

func _ready():
	super()
	default_draw_prio = 1

func _load_kaiju(_kaiju):
	my_kaiju = _kaiju
	_change_image(my_kaiju.kaiju_resource.art)
	sync_kaiju_stats()
	my_kaiju.stats_changed.connect(sync_kaiju_stats)
	my_kaiju.leveled_up.connect(on_kaiju_level_up)
	
func _change_image(new_img):
	$PanelContainer/TextureRect.texture = new_img

func sync_kaiju_stats():
	health_bar.max_value = my_kaiju.base_hp
	health_bar.value = my_kaiju.hp
	health_label.text = str(int(my_kaiju.hp))+"/"+str(int(my_kaiju.base_hp))
	hunger_bar.value = my_kaiju.hunger
	hunger_bar.max_value = my_kaiju.max_hunger
	level_label.text = str(my_kaiju.level)
	xp_bar.max_value = my_kaiju.kaiju_resource.xp_per_level
	xp_bar.value = my_kaiju.xp

func on_kaiju_level_up():
	default_scale  += Vector2(0.1,0.1)
	default_hovered_scale += Vector2(0.1,0.1)
	if currently_hovered:
		scale = default_hovered_scale
	else: scale = default_scale
	if my_kaiju.level == my_kaiju.kaiju_resource.max_level:
		xp_bar.visible = false
