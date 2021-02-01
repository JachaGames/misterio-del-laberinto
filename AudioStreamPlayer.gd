extends AudioStreamPlayer

func _ready():
	PlayerStats.connect("health_changed", self, "hit")
