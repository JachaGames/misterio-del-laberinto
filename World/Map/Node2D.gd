extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var maze1 = $TileMap
onready var maze2 = $TileMap2
onready var maze3 = $TileMap3
enum {
	MAZE_1,
	MAZE_2,
	MAZE_3,
	MAZE_MAX
}
var mazes = {}
var active_maze = MAZE_1

var playerStats = PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready():
	mazes = {
		MAZE_1: maze1,
		MAZE_2: maze2,
		MAZE_3: maze3,
	}
	set_active_maze(active_maze)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("ui_accept") and playerStats.has_sword:
		active_maze = (active_maze + 1) % MAZE_MAX
		set_active_maze(active_maze)

func set_active_maze(maze_id):
	for i in range(MAZE_MAX):
		var maze = mazes[i]
		if i == maze_id:
			maze.show()
			maze.set_collision_layer_bit(0, true)
			maze.set_collision_layer_bit(2, false)
			maze.set_collision_mask_bit(0, true)
			maze.set_collision_mask_bit(2, false)
			maze.occluder_light_mask = 1
		else:
			maze.hide()
			maze.set_collision_layer_bit(0, false)
			maze.set_collision_layer_bit(2, true)
			maze.set_collision_mask_bit(0, false)
			maze.set_collision_mask_bit(2, true)
			maze.occluder_light_mask = 2
