extends Node2D

var clouds_textures = [
	load("res://skybox/cloud1.tres"),
	load("res://skybox/cloud2.tres"),
	load("res://skybox/cloud3.tres"),
	load("res://skybox/cloud4.tres"),
	load("res://skybox/cloud5.tres")
]

export var cloud_count = 50
var current_clouds = []

func _init():
	set_physics_process(true)

func _physics_process(_delta):
	# loop over current clouds, and check if cloud is over the visible viewport
	var new_clouds = []
	for cloud in current_clouds:
		if (cloud as Sprite).position.x < 200:
			new_clouds.append(cloud)
		else:
			# remove old cloud
			(cloud as Node2D).queue_free()

	current_clouds = new_clouds

	# move clouds
	for cloud in current_clouds:
		(cloud as Sprite).position.x += (cloud as Node2D).get_meta("speed", 0.33)

	# spawn new clouds
	if len(current_clouds) < cloud_count:
		for i in cloud_count-len(current_clouds):
			var cloud = Sprite.new()
			var j = int(rand_range(0, len(clouds_textures)))
			cloud.texture = clouds_textures[j]
			cloud.position.x = -160 - cloud.texture.get_width() - rand_range(0, 300)
			cloud.position.y = rand_range(-180, 180)
			var scale = rand_range(1, 2.2)
			cloud.scale = Vector2(scale, scale)
			cloud.z_index = -998
			cloud.set_meta("speed", rand_range(0.1, 0.5))
			self.add_child(cloud)
			current_clouds.append(cloud)
