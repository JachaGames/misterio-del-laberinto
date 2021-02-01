extends Area2D

export(bool) var is_powerup = false
export(bool) var is_win = false
var player = null
var playerStats = PlayerStats

func can_see_player():
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	player = body
	print('player seen')
	if is_powerup:
		playerStats.has_sword = true
	elif is_win:
		playerStats.has_won = true


func _on_PlayerDetectionZone_body_exited(body):
	player = null
