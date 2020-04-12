extends RoomStyle

var corner_mask
var max_number_of_corners : int

const BARREL_SPAWN_CHANCE = .4

var barrels = [
	Tile.new(34, TileMapPackage.LAYERS.props),
	Tile.new(35, TileMapPackage.LAYERS.props),
	Tile.new(38, TileMapPackage.LAYERS.props),
	Tile.new(39, TileMapPackage.LAYERS.props),
	Monument.new(
		[[Tile.new(42, TileMapPackage.LAYERS.floor_decorations), Vector2.ZERO], [StaticStyles.small_circle_shadow_tile, Vector2.ZERO]]
	)
]

func _init(corner_mask = [true, true, true, true], max_number_of_corners = 4):
	randomize()
	self.corner_mask = corner_mask
	self.max_number_of_corners = max_number_of_corners

func decorate(tile_map_package : TileMapPackage, room):
	var num_of_corners = ceil(sin(randf() * PI / 2) * max_number_of_corners)
	var corner_ord = [0, 1, 2, 3]
	corner_ord.shuffle()
	for corner in corner_ord:
		if num_of_corners <= 0:
			return
		if not corner_mask[corner]:
			continue
		num_of_corners -= 1
		var corner_pos = room.position + Vector2(room.size.x - 1 if corner in [1, 3] else 0, room.size.y - 1 if corner in [2, 3] else 0)
		for i in range(0, 3):
			if not randf() <= BARREL_SPAWN_CHANCE:
				continue
			var position = corner_pos
			match i:
				1:
					position += Vector2(1 if corner in [0, 2] else -1, 0)
				2:
					position += Vector2(0, 1 if corner in [0, 1] else -1)
			if blocking_corridor(tile_map_package, room, position):
				continue
			tile_map_package.draw(barrels[randi() % barrels.size()], position)

func blocking_corridor(tile_map_package : TileMapPackage, room, position):
	if position.x == room.position.x:
		if tile_map_package.get_cell(position.x - 1, position.y, TileMapPackage.LAYERS.floor_main) >= 0:
			return true
	if position.x == room.position.x + room.size.x - 1:
		if tile_map_package.get_cell(position.x + 1, position.y, TileMapPackage.LAYERS.floor_main) >= 0:
			return true
	if position.y == room.position.y:
		if tile_map_package.get_cell(position.x, position.y - 1, TileMapPackage.LAYERS.floor_main) >= 0:
			return true
	if position.y == room.position.y + room.size.y - 1:
		if tile_map_package.get_cell(position.x, position.y + 1, TileMapPackage.LAYERS.floor_main) >= 0:
			return true
	return false
