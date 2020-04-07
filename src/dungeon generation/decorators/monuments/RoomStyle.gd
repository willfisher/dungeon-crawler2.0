class_name RoomStyle

var spawnable_monuments
var density

func _init(density, spawnable_monuments = []):
	randomize()
	self.density = density
	self.spawnable_monuments = spawnable_monuments

func add_monument(monument : Monument, probabability, max_per_room = -1):
	spawnable_monuments.append(SpawnableMonument.new(monument, probabability, max_per_room))

func decorate(tile_map, room):
	var area = room.get_area()
	var tiles_filled = []
	
	var usable_monuments = usable_monuments(room)
	var total_used = []
	for i in range(0, usable_monuments.size()):
		total_used.append(0)
	
	while tiles_filled.size() / area < density and usable_monuments.size() > 0:
		for i in range(usable_monuments.size() - 1, -1, -1):
			var monument = usable_monuments[i].monument
			var probability = usable_monuments[i].probability
			var max_per_room = usable_monuments[i].max_per_room
			var available_points = monument.available_points(room, tiles_filled)
			if available_points.size() == 0 or (total_used[i] >= max_per_room and max_per_room >= 0) or (tiles_filled.size() + monument.pattern.size()) / area > density:
				usable_monuments.remove(i)
				total_used.remove(i)
				continue
			if randf() < probability:
				var spawn_point = available_points[randi() % available_points.size()]
				monument.spawn(tile_map, spawn_point)
				for tile in monument.pattern:
					tiles_filled.append(tile[0] - monument.get_center() + spawn_point)
				total_used[i] += 1

func usable_monuments(room):
	var usable_monuments = []
	var area = room.get_area()
	for monument in spawnable_monuments:
		if room.size.x < monument.monument.min_width or room.size.y < monument.monument.min_height:
			continue
		if monument.monument.pattern.size() / area > density:
			continue
		usable_monuments.append(monument)
	return usable_monuments
