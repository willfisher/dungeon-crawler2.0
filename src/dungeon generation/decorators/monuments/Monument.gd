class_name Monument

var spawn_points = []

# n x n matrix of boolean values. Divides room into n^2 squares and each boolean dictates whether it can spawn in that square
var spawn_mask
# radii of spawn from the centers of each square. -1 for anywhere in square
var spawn_radii

var min_dist_from_others
var min_width : int
var min_height : int

# [Tile, position]
var pattern = []

func _init(min_dist_from_others, pattern, min_width, min_height, spawn_mask = [[true]], spawn_radii = [[-1]]):
	self.min_dist_from_others = min_dist_from_others
	self.pattern = pattern
	self.min_width = min_width
	self.min_height = min_height
	self.spawn_mask = spawn_mask
	self.spawn_radii = spawn_radii

func offset(offset : Vector2) -> Monument:
	var offset_pattern = []
	for tile in pattern:
		offset_pattern.append([tile[0], tile[1] + offset])
	return get_script().new(
		min_dist_from_others,
		offset_pattern,
		min_width,
		min_height,
		spawn_mask,
		spawn_radii
	)

func adjoin(monument : Monument) -> Monument:
	return get_script().new(
		max(min_dist_from_others, monument.min_dist_from_others),
		pattern + monument.pattern,
		max(min_width, monument.min_width),
		max(min_height, monument.min_height),
		spawn_mask,
		spawn_radii
	)

########## Utility Methods #############
func add_spawn_point(pos, radius):
	spawn_points.append([pos, radius])

func spawn(tile_map_package : TileMapPackage, center):
	var offset = center - get_center()
	for tile in pattern:
		if tile[0].tile_index < 0:
			continue
		tile_map_package.draw_tile(tile[0], tile[1] + offset)

func get_bounds() -> Vector2:
	var bounds = Rect2(Vector2.ZERO, Vector2.ZERO)
	for tile in pattern:
		bounds = bounds.merge(Rect2(tile[1], Vector2(1,1)))
	return bounds

func get_center() -> Vector2:
	var bounds = get_bounds()
	return (bounds.position + bounds.size / 2).floor()

func get_absolute_bounds(center):
	var bounds = get_bounds()
	return Rect2(bounds.position - get_center() + center, bounds.size)

func get_tiles_used(center):
	var tiles_filled = []
	var _center = get_center()
	for tile in pattern:
		var position = tile[1] - _center + center
		if not tiles_filled.has(position):
			tiles_filled.append(position)
	return tiles_filled

func available_points(room, tiles_filled):
	var available_points = []
	for x in range(room.position.x, room.position.x + room.size.x):
		for y in range(room.position.y, room.position.y + room.size.y):
			if in_spawn_mask(room, Vector2(x, y)) and fits(room, Vector2(x, y)) and is_separated(tiles_filled, Vector2(x, y)):
				available_points.append(Vector2(x, y))
	return available_points

func fits(container, center):
	return container.encloses(get_absolute_bounds(center))

func in_spawn_mask(room, center):
	var steps = room.size / spawn_mask.size()
	for i in range(0, spawn_mask.size()):
		for j in range(0, spawn_mask.size()):
			var container = Rect2(room.position + Vector2(steps.x * i, steps.y * j), steps)
			if not container.has_point(center):
				continue
			if not spawn_mask[i][j]:
				return false
			return spawn_radii[i][j] < 0 or floor((container.position + container.size / 2).floor().distance_to(center)) <= spawn_radii[i][j]
	return false

func is_separated(tiles_filled, center):
	var offset = center - get_center()
	for occupied_tile in tiles_filled:
		for tile in pattern:
			if floor((tile[1] + offset).distance_to(occupied_tile)) < min_dist_from_others:
				return false
	return true
