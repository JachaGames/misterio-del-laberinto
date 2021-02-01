extends StaticBody2D

var stats = PlayerStats
onready var animationPlayer = $AnimationPlayer

func _ready():
	print('init tree')
	animationPlayer.play("Pulse")
	

func got_sword():
	stats.has_sword = true


func _on_PowerUp_area_entered(area):
	print('powerup entered')
	got_sword()


func _on_Tree_input_event(viewport, event, shape_idx):
	print('tree')


func _on_PowerUp_area_shape_entered(area_id, area, area_shape, self_shape):
	print('hit')
