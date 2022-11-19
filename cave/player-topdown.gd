extends KinematicBody2D

const SPEED = Vector2(6000, 4800)

export var health := 10
export var max_health := 10
export var heal_delay := 0.1

export var enemy_exists: bool = true

onready var _door: StaticBody2D = $"/root/Node2D/Door"
onready var _enemy: KinematicBody2D = $"/root/Node2D/Enemy"

onready var _tip: Label = $"Tip/Label"
onready var _tip_tex: NinePatchRect = $"Tip"

var _tips = {
	"door_key_required": "Press C/LMB to use the key (staff).",
	"atak_to_not_die": "WE ARE BEING ATAK'D!! USE LMB/C TO FIGHT BACK!! AAAAA--"
}

func show_tip(name: String):
	_tip.text = _tips[name]
	_tip_tex.rect_size = _tip.rect_size + Vector2(4, 4)

var _time_since_last_heal: float = 0

func _physics_process(delta: float):
	var vel := Vector2(
		(Input.get_action_strength("move_right") - Input.get_action_strength("move_left")),
		(Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")))
	
	vel = vel.normalized() * delta * SPEED
	
	move_and_slide(vel, Vector2.UP)
	
	var colliding_with_door  := false
	var colliding_with_enemy := false
	
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		
		if _door == collision.collider:
			colliding_with_door = true
			show_tip("door_key_required")
		
		if _enemy == collision.collider:
			colliding_with_enemy = true
			show_tip("atak_to_not_die")
	
	_tip_tex.visible = colliding_with_door or colliding_with_enemy
	
	if colliding_with_door and not enemy_exists and Input.is_action_pressed("melee_attack"):
		get_tree().change_scene("res://base-scene.tscn")

	if enemy_exists:
		if colliding_with_enemy:
			if Input.is_action_pressed("melee_attack"):
				_enemy.health -= 1
			else:
				health -= 1
		elif self.position.distance_to(_enemy.position) > 10 and health < max_health:
			if _time_since_last_heal >= heal_delay:
				health += 1
				_time_since_last_heal = 0
			else:
				_time_since_last_heal += delta

		print(_enemy.health, "; ", health)
