extends Node

export(int) var max_health = 1 setget set_max_health

export(bool) var has_sword = false setget set_has_sword
export(bool) var has_won = false setget set_has_won
export(bool) var has_shield = false

var health = max_health setget set_health
var attempts = 0

var sceneChanger = SceneChanger

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal victory
signal has_sword_changed(value)

func set_has_won(value):
	has_won = value
	print('WIN: ' + str(value))
	if has_won == true and has_sword == true:
		emit_signal("victory")

func set_has_sword(value):
	has_sword = value
	print('has sword changed to ' + str(value))
	emit_signal("has_sword_changed", value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
#	print('ouch', health)
	
	if health <= 0:
		print("signal: no health!")
		emit_signal("no_health")


func _ready():
	self.health = max_health
	

func got_sword():
	self.has_sword = true
	
func reset():
	print('reset')
	attempts += 1
	health = max_health
	self.has_sword = false
	self.has_won = false
	
