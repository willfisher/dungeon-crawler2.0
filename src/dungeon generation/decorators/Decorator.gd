# [RoomStyle, probability]
var room_styles = []

var total_probability : float

func _init(room_styles = []):
	randomize()
	self.room_styles = room_styles
	total_probability = 0
	for room_style in room_styles:
		total_probability += room_style[1]
	
func decorate(tile_map, rooms):
	for room in rooms:
		decorate_room(tile_map, room)

func decorate_room(tile_map, room):
	var prob = randf() * total_probability
	var running_prob = 0
	for room_style in room_styles:
		if prob >= running_prob and prob < running_prob + room_style[1]:
			room_style[0].decorate(tile_map, room)
			return
		running_prob += room_style[1]

func add_room_style(room_style, probability):
	room_styles.append([room_style, probability])
	total_probability += probability
