var floor_tile : Tile
var wall_tile : Tile

func _init(floor_tile, wall_tile):
	self.floor_tile = floor_tile
	self.wall_tile = wall_tile

func tile(tile_map_package : TileMapPackage, dungeon, refresh_bitmap = true):
	tile_floors(tile_map_package, dungeon, false)
	tile_corridors(tile_map_package, dungeon, false)
	tile_walls(tile_map_package, dungeon, false)
	
	if refresh_bitmap:
		refresh_bitmap(tile_map_package)

func tile_floors(tile_map_package : TileMapPackage, dungeon, refresh_bitmap = true):
	var rooms = dungeon.rooms
	var path = dungeon.path
	
	# Carve rooms
	var corridors = []  # One corridor per connection
	for room in rooms:
		for x in range(room.position.x, room.position.x + room.size.x):
			for y in range(room.position.y, room.position.y + room.size.y):
				tile_map_package.draw_tile(floor_tile, Vector2(x, y))
		
	if refresh_bitmap:
		refresh_bitmap(tile_map_package)

func tile_walls(tile_map_package : TileMapPackage, dungeon, refresh_bitmap = true):
	var bounds = dungeon.get_bounds()
	var topleft = bounds.position
	var bottomright = bounds.end
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y - 1, bottomright.y):
			if tile_map_package.get_cell(x, y + 1, floor_tile.layer) == floor_tile.tile_index and tile_map_package.get_cell(x, y, floor_tile.layer) == -1:
				tile_map_package.draw_tile(wall_tile, Vector2(x, y))
	
	if refresh_bitmap:
		refresh_bitmap(tile_map_package)

func tile_corridors(tile_map_package : TileMapPackage, dungeon, refresh_bitmap = true):
	var rooms = dungeon.rooms
	var path = dungeon.path
	# Carve rooms
	var corridors = []  # One corridor per connection
	for room in rooms:
		# Carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x + room.size.x / 2, 
											room.position.y + room.size.y / 2, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Vector2(path.get_point_position(p).x,
													path.get_point_position(p).y)
				var end = Vector2(path.get_point_position(conn).x,
													path.get_point_position(conn).y)
				carve_path(tile_map_package, start, end)
		corridors.append(p)
	
	if refresh_bitmap:
		refresh_bitmap(tile_map_package)

func carve_path(tile_map_package : TileMapPackage, pos1, pos2):
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
		tile_map_package.draw_tile(floor_tile, Vector2(x, x_y.y))
		tile_map_package.draw_tile(floor_tile, Vector2(x, x_y.y + y_diff))  # widen the corridor
	for y in range(pos1.y, pos2.y, y_diff):
		tile_map_package.draw_tile(floor_tile, Vector2(y_x.x, y))
		tile_map_package.draw_tile(floor_tile, Vector2(y_x.x + x_diff, y))

func refresh_bitmap(tile_map_package):
	tile_map_package.get_layer(floor_tile.layer).update_bitmask_region()
	if floor_tile.layer != wall_tile.layer:
		tile_map_package.get_layer(wall_tile.layer).update_bitmask_region()
