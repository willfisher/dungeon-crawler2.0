class_name TileMapPackage

enum LAYERS {
	floor_main,
	floor_decorations,
	shadows,
	props
}

var floor_main : TileMap
var floor_decorations : TileMap
var shadows : TileMap
var props : TileMap

func _init(floor_main, floor_decorations, shadows, props):
	self.floor_main = floor_main
	self.floor_decorations = floor_decorations
	self.shadows = shadows
	self.props = props

func draw(object, position : Vector2) -> void:
	if object is Tile:
		draw_tile(object, position)
	elif object is Monument:
		object.spawn(self, position)

func draw_tile(tile : Tile, position : Vector2) -> void:
	draw_by_id(tile.tile_index, tile.layer, position)

func draw_by_id(tile_index : int, layer, position : Vector2) -> void:
	get_layer(layer).set_cellv(position, tile_index)

func get_cell(x, y, layer):
	return get_layer(layer).get_cell(x, y)

func get_cellv(position, layer):
	return get_layer(layer).get_cellv(position)

func get_layer(layer):
	match layer:
		LAYERS.floor_main:
			return floor_main
		LAYERS.floor_decorations:
			return floor_decorations
		LAYERS.shadows:
			return shadows
		LAYERS.props:
			return props
