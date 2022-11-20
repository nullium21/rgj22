extends Control

var max_hearts = 3 setget set_max_hearts
var hearts = 3 setget set_hearts
var is_paused = false setget set_is_paused

onready var heartUIFull = $HeartsUIFull
onready var heartUIEmpty = $HeartsUIEmpty
onready var pauseButton = $Pause
onready var phone = $Pause/Sprite
onready var playButton = $Pause/TextureButton

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 16

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 16
	
func _ready():
	phone.visible = false
	playButton.visible = false
	self.max_hearts = Stats.max_health
	self.hearts = Stats.health
	Stats.connect("health_changed", self, "set_hearts")
	Stats.connect("max_health_changed", self, "set_max_hearts")

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	phone.visible = is_paused
	playButton.visible = is_paused

func _on_TextureButton_pressed():
	print("on texture button pressed")
	set_is_paused(!self.is_paused)

func _on_Pause_pressed():
	print("on pause pressed")
	set_is_paused(!self.is_paused)
