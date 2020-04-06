extends Node2D

signal dungeon_generated

var generator = preload("res://src/levels/dungeon generation/generators/PhysicsGeneration.gd").new()
var tiler

onready var Map = $Floor

export(int) var floor_tile_id = 3
export(int) var wall_tile_id = 0

func _ready():
	yield(get_tree(), "idle_frame")
	var dungeon = yield(generator.generate(get_tree()), "completed")
	make_map(dungeon)
	make_walls(dungeon)
	Map.update_bitmask_region()
	emit_signal("dungeon_generated", dungeon)

func make_map(dungeon):
	# Create a TileMap from the generated rooms and path
	Map.clear()
	
	var rooms = dungeon.rooms
	var path = dungeon.path
	
	# Carve rooms
	var corridors = []  # One corridor per connection
	for room in rooms:
		for x in range(room.position.x, room.position.x + room.size.x):
			for y in range(room.position.y, room.position.y + room.size.y):
				Map.set_cell(x, y, floor_tile_id)
		# Carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x + room.size.x / 2, 
											room.position.y + room.size.y / 2, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Vector2(path.get_point_position(p).x,
													path.get_point_position(p).y)
				var end = Vector2(path.get_point_position(conn).x,
													path.get_point_position(conn).y)
				carve_path(start, end)
		corridors.append(p)

func make_walls(dungeon):
	var bounds = dungeon.get_bounds()
	var topleft = bounds.position
	var bottomright = bounds.end
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			if Map.get_cell(x, y + 1) == floor_tile_id and Map.get_cell(x, y) == -1:
				Map.set_cell(x, y, wall_tile_id)

func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, floor_tile_id)
		Map.set_cell(x, x_y.y + y_diff, floor_tile_id)  # widen the corridor
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, floor_tile_id)
		Map.set_cell(y_x.x + x_diff, y, floor_tile_id)
