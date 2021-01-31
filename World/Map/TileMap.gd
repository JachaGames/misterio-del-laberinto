extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {
	Vector2.RIGHT: E,
	Vector2.LEFT: W,
	Vector2.UP: N,
	Vector2.DOWN: S
}
var tile_size = 64  # tile size (in pixels)
var width = 16  # width of map (in tiles)
var height = 9  # height of map (in tiles)
var maze_size = Vector2(width, height)
var mino_lair_size = Vector2(4, 3)
var chamber_size = Vector2(2, 2)

enum MAZES { MAZE_1, MAZE_2, MAZE_3 }
export(MAZES) var maze_id

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	tile_size = cell_size
	make_maze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func fill_area(start_v, size_v, tile_id, unvisited, doors):
	var current_tile = start_v
	for x in range(size_v.x):
		for y in range(size_v.y):
			current_tile = start_v + Vector2(x, y)
			var index = unvisited.find(current_tile)
			if index != -1:
				unvisited.remove(index)
				set_cellv(current_tile, tile_id)
	if doors:
		if start_v.y - 1 >= 0:
			set_cellv(Vector2(start_v.x + (randi() % int(size_v.x)), start_v.y - 1), N|E|W)
		if start_v.y + size_v.y < maze_size.y:
			set_cellv(Vector2(start_v.x + (randi() % int(size_v.x)), start_v.y + size_v.y), S|E|W)
		if start_v.x - 1 >= 0:
			set_cellv(Vector2(start_v.x - 1, start_v.y + (randi() % int(size_v.y))), N|S|W)
		if start_v.x + size_v.x < maze_size.x:
			set_cellv(Vector2(start_v.x + size_v.x, start_v.y + (randi() % int(size_v.y))), N|S|E)

func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	clear()
	for x in range(maze_size.x):
		for y in range(maze_size.y):
			unvisited.append(Vector2(x, y))
			set_cellv(Vector2(x, y), N|E|S|W)
	
	# create minotaur lair
	var mino_lair_start = maze_size - mino_lair_size
	mino_lair_start = Vector2(ceil(mino_lair_start.x/2), ceil(mino_lair_start.y/2))
	fill_area(mino_lair_start, mino_lair_size, 16, unvisited, true)
	
	# create additional chambers
	fill_area(maze_size - chamber_size, chamber_size, 16, unvisited, maze_id == MAZES.MAZE_3)
	fill_area(Vector2(0, maze_size.y - chamber_size.y), chamber_size, 16, unvisited, maze_id == MAZES.MAZE_1)
	fill_area(Vector2(maze_size.x - chamber_size.x, 0), chamber_size, 16, unvisited, maze_id == MAZES.MAZE_2)
	
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = get_cellv(current) - cell_walls[dir]
			var next_walls = get_cellv(next) - cell_walls[-dir]
			set_cellv(current, current_walls)
			set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
