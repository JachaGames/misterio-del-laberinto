extends CanvasLayer

signal scene_changed()

onready var animationPlayer = $AnimationPlayer
onready var black = $Control/Black

func _ready():
	connect("scene_changed", PlayerStats, "reset")

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animationPlayer.play("Fade")
	yield(animationPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animationPlayer.play_backwards("Fade")
	yield(animationPlayer, "animation_finished")
	emit_signal("scene_changed")
