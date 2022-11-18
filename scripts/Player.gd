extends KinematicBody2D

export var speed = 100
export var gravity = 10
export var jump = 125

var velocity = Vector2.ZERO

func _physics_process(_delta):
	# gravity force
	velocity.y += gravity
	
	# reset x velocity on each frame
	velocity.x = 0
	# left/right
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump
		
	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
