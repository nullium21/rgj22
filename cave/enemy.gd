extends KinematicBody2D

export var SPEED = 600
onready var RETREAT_SPEED = SPEED * -1.5

export var health = 5
export var max_health = 5
export var retreat_health_trigger = 2
export var heal_delay := 0.1

onready var _player: KinematicBody2D = $"/root/Node2D/Player"

var _raycast := RayCast2D.new()

var _time_since_last_heal: float = 0

func _physics_process(delta: float):
	var self_pos = self.position
	var player_pos = _player.position
	
	var delta_pos = player_pos - self_pos
	
	_raycast.position = self_pos
	_raycast.cast_to = delta_pos
	
	var should_retreat = health < retreat_health_trigger

	if not _raycast.is_colliding(): # player is visible
		var speed = RETREAT_SPEED if should_retreat else SPEED
		
		self.move_and_slide(delta_pos * delta * speed)

	if health <= 0:
		_player.enemy_exists = false
		self.queue_free()

	if health < max_health and self_pos.distance_to(player_pos) > 10:
		if _time_since_last_heal > heal_delay:
			health += 1
			_time_since_last_heal = 0
		else:
			_time_since_last_heal += heal_delay
