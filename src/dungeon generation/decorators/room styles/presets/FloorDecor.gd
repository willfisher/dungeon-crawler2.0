extends RoomStyle

const MAX_DENSITY = 0.05

var floor_decor = [
	Monument.new([[Tile.new(40, TileMapPackage.LAYERS.floor_decorations), Vector2.ZERO], [StaticStyles.small_circle_shadow_tile, Vector2.ZERO]]),
	Monument.new([[Tile.new(41, TileMapPackage.LAYERS.floor_decorations), Vector2.ZERO], [StaticStyles.small_circle_shadow_tile, Vector2.ZERO]]),
	Monument.new([[Tile.new(42, TileMapPackage.LAYERS.floor_decorations), Vector2.ZERO], [StaticStyles.small_circle_shadow_tile, Vector2.ZERO]])
]

func _init():
	randomize()

func decorate(tile_map_package : TileMapPackage, room):
	var density = sin(randf() * PI / 2) * MAX_DENSITY
	var count = 0
	var area = room.get_area()
	var available_tiles = get_available_tiles(tile_map_package, room)
	available_tiles.shuffle()
	for tile in available_tiles:
		if (count + 1) / area > density:
			return
		tile_map_package.draw(floor_decor[randi() % floor_decor.size()], tile)
		count += 1

func get_available_tiles(tile_map_package : TileMapPackage, room : Rect2):
	var available_tiles = []
	for x in range(room.position.x, room.position.x + room.size.x):
		for y in range(room.position.y, room.position.y + room.size.y):
			if tile_map_package.get_cell(x, y, TileMapPackage.LAYERS.floor_decorations) < 0 and tile_map_package.get_cell(x, y, TileMapPackage.LAYERS.shadows) < 0 and tile_map_package.get_cell(x, y, TileMapPackage.LAYERS.props) < 0:
				available_tiles.append(Vector2(x, y))
	return available_tiles
