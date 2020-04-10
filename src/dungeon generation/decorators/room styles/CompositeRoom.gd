extends RoomStyle

var styles = []

func _init(styles):
	self.styles = styles
	for style in styles:
		min_dim = Vector2(max(min_dim.x, style.min_dim.x), max(min_dim.y, style.min_dim.y))
		max_dim = Vector2(min(max_dim.x, style.max_dim.x), min(max_dim.y, style.max_dim.y))

func decorate(tile_map_package, room):
	for style in styles:
		style.decorate(tile_map_package, room)
