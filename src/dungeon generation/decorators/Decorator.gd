# [RoomStyle, probability]
var room_styles = []

func _init(room_styles = []):
	randomize()
	self.room_styles = room_styles
	
func decorate(tile_map_package : TileMapPackage, rooms):
	for room in rooms:
		decorate_room(tile_map_package, room)

func decorate_room(tile_map_package : TileMapPackage, room):
	var valid_styles = []
	var total_probability = 0
	for style in room_styles:
		if style[0].fits(room):
			valid_styles.append(style)
			total_probability += style[1]
	if not valid_styles:
		return
	var prob = randf() * total_probability
	var running_prob = 0
	for style in valid_styles:
		if prob >= running_prob and prob < running_prob + style[1]:
			style[0].decorate(tile_map_package, room)
			return
		running_prob += style[1]

func add_room_style(room_style, probability):
	room_styles.append([room_style, probability])
