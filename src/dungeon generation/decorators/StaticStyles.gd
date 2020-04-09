extends Node

################## PRE-DEFINED TILES #######################
const EMPTY_ID = -1
var empty_tile = Tile.new(
	EMPTY_ID,
	TileMapPackage.LAYERS.props
)
const FLOOR_ID = 3
var floor_tile = Tile.new(
	FLOOR_ID,
	TileMapPackage.LAYERS.floor_main
)
const WALLS_ID = 0
var wall_tile = Tile.new(
	WALLS_ID,
	TileMapPackage.LAYERS.floor_main
)
const TABLE_HORIZONTAL_ID = 9
var table_horizontal_tile = Tile.new(
	TABLE_HORIZONTAL_ID,
	TileMapPackage.LAYERS.props
)
const TABLE_SIDEWAYS_ID = 10
var table_sideways_tile = Tile.new(
	TABLE_SIDEWAYS_ID,
	TileMapPackage.LAYERS.props
)
const CHAIR_ID = 7
var chair_tile = Tile.new(
	CHAIR_ID,
	TileMapPackage.LAYERS.props
)
const BOOK_ID = 13
var book_tile = Tile.new(
	BOOK_ID,
	TileMapPackage.LAYERS.props
)
const ALTAR_SINGLE_ID = 11
var altar_single_tile = Tile.new(
	ALTAR_SINGLE_ID,
	TileMapPackage.LAYERS.props
)
const SMALL_OVAL_SHADOW_ID = 19
var small_oval_shadow_tile = Tile.new(
	SMALL_OVAL_SHADOW_ID,
	TileMapPackage.LAYERS.shadows
)
const SMALL_CIRCLE_SHADOW_ID = 32
var small_circle_shadow_tile = Tile.new(
	SMALL_CIRCLE_SHADOW_ID,
	TileMapPackage.LAYERS.shadows
)
const LARGE_OVAL_SHADOW_ID = 20
var large_oval_shadow_tile = Tile.new(
	LARGE_OVAL_SHADOW_ID,
	TileMapPackage.LAYERS.shadows
)
const LARGE_CIRCLE_SHADOW_ID = 33
var large_circle_shadow_tile = Tile.new(
	LARGE_CIRCLE_SHADOW_ID,
	TileMapPackage.LAYERS.shadows
)
const STONE_TILE_ID = 31
var stone_tile = Tile.new(
	STONE_TILE_ID,
	TileMapPackage.LAYERS.floor_decorations
)

################## PRE-DEFINED MONUMENTS ##################
var chair = Monument.new(
	1,
	[[chair_tile, Vector2(0,0)], [small_circle_shadow_tile, Vector2(0,0)]],
	1, 1
)
var table = Monument.new(
	3,
	[[table_horizontal_tile, Vector2.ZERO], [empty_tile, Vector2(0,1)],
	[empty_tile, Vector2(1,1)], [large_circle_shadow_tile, Vector2(0,1)]],
	4, 4,
	[[false, false, false], [false, true, false], [false, false, false]],
	[[0,0,0],[0,1,0],[0,0,0]]
)
var table_chair = table.adjoin(chair.offset(Vector2(2, 1)))

var altar = Monument.new(
	2, [[altar_single_tile, Vector2(0,0)]], 0, 0
)
var stone_border = Monument.new(
	2,
	[[stone_tile, Vector2(0,0)], [stone_tile, Vector2(1,0)], [stone_tile, Vector2(2,0)],
	[stone_tile, Vector2(0,1)], [stone_tile, Vector2(2,1)], [stone_tile, Vector2(0,2)],
	[stone_tile, Vector2(1,2)], [stone_tile, Vector2(2,2)]],
	3, 3,
	[[false, false, false], [false, true, false], [false, false, false]],
	[[0,0,0],[0,0,0],[0,0,0]]
)
var stone_altar = stone_border.adjoin(altar.offset(Vector2(1,1)))

var default_room_1 = RoomStyle.new(
	.1, [
		SpawnableMonument.new(
			altar, 1, 2
		),
		SpawnableMonument.new(
			table_chair, .1, 1
		)
	]
)
var default_room_2 = RoomStyle.new(
	1, [
		SpawnableMonument.new(
			stone_altar, 1, 1
		)
	]
)
