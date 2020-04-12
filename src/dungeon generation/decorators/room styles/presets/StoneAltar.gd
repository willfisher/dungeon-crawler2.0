extends RoomStyle

var stone_border = Monument.new(
	[[StaticStyles.stone_tile, Vector2(0,0)], [StaticStyles.stone_tile, Vector2(1,0)], [StaticStyles.stone_tile, Vector2(2,0)],
	[StaticStyles.stone_tile, Vector2(0,1)], [StaticStyles.stone_tile, Vector2(1,1)], [StaticStyles.stone_tile, Vector2(2,1)],
	[StaticStyles.stone_tile, Vector2(0,2)], [StaticStyles.stone_tile, Vector2(1,2)], [StaticStyles.stone_tile, Vector2(2,2)]]
)
var altars = [
	Tile.new(43, TileMapPackage.LAYERS.props),
	Tile.new(44, TileMapPackage.LAYERS.props),
	Tile.new(45, TileMapPackage.LAYERS.props)
]
var empty_altar = Tile.new(46, TileMapPackage.LAYERS.props)

const SIDE_ALTAR_MIN_DIM : Vector2 = Vector2(12, 12)
const SIDE_ALTAR_PROB = 1

func _init():
	min_dim = Vector2(10, 10)

func decorate(tile_map_package : TileMapPackage, room : Rect2):
	var center = (room.position + room.size / 2).floor()
	tile_map_package.draw(stone_border, center)
	tile_map_package.draw(altars[randi() % altars.size()], center)
	if room.size.x >= SIDE_ALTAR_MIN_DIM.x and room.size.y >= SIDE_ALTAR_MIN_DIM.y:
		if randf() <= SIDE_ALTAR_PROB:
			tile_map_package.draw(empty_altar, center - Vector2(3, 0))
			tile_map_package.draw(empty_altar, center + Vector2(3, 0))
