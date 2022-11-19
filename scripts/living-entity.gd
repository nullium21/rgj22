extends KinematicBody2D

export var speed = 100
export var gravity_enabled = true
export var gravity = 10
export var jump = 125

export var ai_enabled = false
export var ai_retreat_speed_modifier = 1.5
export var ai_retreat_health_trigger = 0.4
export var ai_attack_cooldown        = 0.3

export var max_health = 5
export var health     = 5
export var heal_delay = 0.1

var velocity = Vector2.ZERO

onready var _tip: Label = $"Tip/Label"
onready var _tip_tex: NinePatchRect = $"Tip"

var _tips = {
	"door_key_required": "Press C/LMB to use the key (staff).",
	"atak_to_not_die": "WE ARE BEING ATAK'D!! USE LMB/C TO FIGHT BACK!! AAAAA--"
}

func _ready():
	add_to_group("ai_entity" if ai_enabled else "not_ai_entity")

var _time_since_last_heal: float = 0
var _time_since_last_ai_attack: float = 0

func show_tip(name: String):
	if _tip == null or _tip_tex == null:
		return
	
	_tip.text = _tips[name]
	_tip_tex.rect_size = _tip.rect_size + Vector2(4, 4)

func _physics_process(delta):
	if gravity_enabled:
		# apply gravity force
		velocity.y += gravity
		# reset y velocity, if player is on ground
		if is_on_floor():
			velocity.y = 0
	
	if ai_enabled:
		var enemies := get_tree().get_nodes_in_group("not_ai_entity")
		var should_retreat = health < (ai_retreat_health_trigger * max_health)

		var direction = Vector2.ZERO
		for enemy in enemies:
			direction += (enemy.position - self.position)
		direction /= enemies.size()

		velocity = direction * ((-ai_retreat_speed_modifier) if should_retreat else 1)
	else:
		velocity.x = speed * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
		
		if gravity_enabled:
			# jumping
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = -jump
		else:
			velocity.y = speed * (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	var tip_shown = false
	
	# check for collision with teleport (door)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == null:
			continue
		var collider = get_tree().root.get_node(collision.collider.get_path())
		if ai_enabled:
			if collider.is_in_group("not_ai_entity"):
				if _time_since_last_ai_attack < ai_attack_cooldown:
					_time_since_last_ai_attack += delta
				else:
					collider.health = collider.health - 1
					_time_since_last_ai_attack = 0
		else:
			if collider.is_in_group("ai_entity"):
				show_tip("atak_to_not_die")
				tip_shown = true
				if Input.is_action_pressed("melee_attack"):
					collider.health -= 1
			if collider.is_in_group("teleport-spawn"):
				get_tree().change_scene("res://base-scene.tscn")
			elif collider.is_in_group("teleport-platformer"):
				get_tree().change_scene("res://platformer-scene.tscn")
			elif collider.is_in_group("door"):
				show_tip("door_key_required")
				tip_shown = true
				if Input.is_action_pressed("melee_attack"):
					get_tree().change_scene("res://door-minigame/scene.tscn")
			elif collider.is_in_group("magic-fern"):
				# TODO: play some animation, etc.
				get_tree().change_scene("res://cave/scene.tscn")
	
	if _tip_tex != null:
		_tip_tex.visible = tip_shown
	
	if ai_enabled and health <= 0:
		self.queue_free()

	move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	var distance_to_closest_enemy = INF
	for enemy in get_tree().get_nodes_in_group("not_ai_entity" if ai_enabled else "ai_entity"):
		if self.position.distance_to(enemy.position) < distance_to_closest_enemy:
			distance_to_closest_enemy = self.position.distance_to(enemy.position)
	
	if distance_to_closest_enemy > 10 and health < max_health:
		if _time_since_last_heal >= heal_delay:
			health += 1
			_time_since_last_heal = 0
		else:
			_time_since_last_heal += delta
