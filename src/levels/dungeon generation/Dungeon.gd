class_name Dungeon

var rooms
var path

func _init(rooms, path):
	self.rooms = rooms
	self.path = path
	
func spawn_point() -> Vector2:
	var start_room = null
	var min_x = INF
	for room in rooms:
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x
	return start_room.position + start_room.size / 2

func get_bounds():
	var bounds = Rect2()
	for room in rooms:
		bounds = bounds.merge(room)
	return bounds
