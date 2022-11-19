extends KinematicBody2D

export var speed = 100
export var gravity_enabled = true
export var gravity = 10
export var jump = 125

var velocity = Vector2.ZERO

func _physics_process(_delta):
	if gravity_enabled:
		# apply gravity force
		velocity.y += gravity
		# reset y velocity, if player is on ground
		if is_on_floor():
			velocity.y = 0
	
	# reset x velocity on each frame
	velocity.x = 0
	# left/right
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	
	if gravity_enabled:
		# jumping
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump
	else:
		velocity.y = 0
		if Input.is_action_pressed("move_up"):
			velocity.y = -speed
		if Input.is_action_pressed("move_down"):
			velocity.y = speed
	
	# check for collision with teleport (door)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("teleport-spawn"):
			get_tree().change_scene("res://base-scene.tscn")
		elif collision.collider.is_in_group("teleport-platformer"):
			get_tree().change_scene("res://platformer-scene.tscn")
		elif collision.collider.is_in_group("magic-fern"):
			# TODO: play some animation, etc.
			get_tree().change_scene("res://base-scene.tscn")
		
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
