extends Node2D

export var time_between_chars = 0.1
export var time_between_lines = 0.2

onready var _bottom_collider = $"BottomCollider"
onready var _last_text_label = $"LastText"
onready var _to_be_continued = $"To Be Continued"

var _current_text := 0
var _current_char := 0
var _texts := [
	"So you did it.",
	"Congratulations.",
	"Now...", 1,
	"You've heard about her, right?", 1,
	"Oh, you haven't?",
	"Heh. Then...",
	"...",
	".....",
	".......",
	"I guess we'll let you know once it's time.",
	"So...", 1,
	"Farewell."
]

var _time_since_last_update := 0
var _should_update := false

func _physics_process(delta: float):
	pass
