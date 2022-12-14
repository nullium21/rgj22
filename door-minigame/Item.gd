extends TextureRect

func get_drag_data(position):
	var data = {}
	data["origin_texture"] = texture
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.rect_size = Vector2(16, 16)
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	set_drag_preview(control)
	return data

func can_drop_data(position, data):
	return true
	return false

func drop_data(position, data):
	self.rect_size = Vector2(16, 16)
	texture = data["origin_texture"]
