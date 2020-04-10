class_name RoomStyle

var min_dim : Vector2 = Vector2.ZERO
var max_dim : Vector2 = Vector2.INF

func _init(min_dim : Vector2 = Vector2.ZERO, max_dim : Vector2 = Vector2.INF):
	self.min_dim = min_dim
	self.max_dim = max_dim
	
func fits(room : Rect2):
	return min_dim.x <= room.size.x and min_dim.y <= room.size.y and max_dim.x >= room.size.x and max_dim.y >= room.size.y
