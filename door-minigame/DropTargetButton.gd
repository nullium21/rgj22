extends TextureButton

func _ready():
	pass # Replace with function body.

func can_drop_data(position, data):
	return true

func drop_data(position, data):
	self.rect_size = Vector2(32, 32)
	texture_normal = data["origin_texture"]
	disabled = false

func _process(delta):
	if pressed:
		get_tree().change_scene("res://platformer/scene.tscn")
