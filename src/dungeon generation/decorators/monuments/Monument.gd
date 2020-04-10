class_name Monument

# [Tile, position]
var pattern = []

func _init(pattern):
	self.pattern = pattern

func offset(offset : Vector2) -> Monument:
	var offset_pattern = []
	for tile in pattern:
		offset_pattern.append([tile[0], tile[1] + offset])
	return get_script().new(
		offset_pattern
	)

func adjoin(monument : Monument) -> Monument:
	return get_script().new(
		pattern + monument.pattern
	)

########## Utility Methods #############
func spawn(tile_map_package, center):
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

func fits(container, center):
	return container.encloses(get_absolute_bounds(center))
