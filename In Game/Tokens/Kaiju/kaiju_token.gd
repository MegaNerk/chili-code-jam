extends TokenPin
class_name KaijuToken

var my_kaiju : Kaiju

func _load_kaiju(_kaiju):
	my_kaiju = _kaiju
	_change_image(my_kaiju.kaiju_resource.art)
	
func _change_image(new_img):
	$PanelContainer/TextureRect.texture = new_img
