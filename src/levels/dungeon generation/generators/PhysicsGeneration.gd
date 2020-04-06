var path_tools = preload("res://src/util/PathTools.gd")

var Room = preload("res://src/levels/dungeon generation/generators/Room.tscn")

var num_rooms : int  # number of rooms to generate
var min_size : int  # minimum room size (in tiles)
var max_size : int  # maximum room size (in tiles)
var hspread : int  # horizontal spread (in pixels)
var cull : int  # chance to cull room

func _init(num_rooms = 50, min_size = 6, max_size = 15, hspread = 25, cull = 0.5):
	self.num_rooms = num_rooms
	self.min_size = min_size + 2
	self.max_size = max_size + 2
	self.hspread = hspread
	self.cull = cull

func generate(physics_base):
	randomize()
	var room_holder = Node.new()
	physics_base.root.add_child(room_holder)
	
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h))
		room_holder.add_child(r)
	# wait for movement to stop
	yield(physics_base.create_timer(.5), 'timeout')
	# cull rooms
	for room in room_holder.get_children():
		if randf() < cull:
			room.queue_free()
	
	# grab room data
	var rooms = []
	var room_positions = []
	for room in room_holder.get_children():
		var s = room.size.floor()
		var ul = (room.position - room.size / 2).floor()
		# trim room size so that adjacent rooms dont touch
		rooms.append(Rect2(ul + Vector2(1, 1), s - Vector2(2, 2)))
		room_positions.append(Vector3(room.position.x, room.position.y, 0))
	
	# remove room holder
	room_holder.queue_free()
	
	# generate a minimum spanning tree connecting the rooms
	var path = path_tools.find_mst(room_positions)
	
	return Dungeon.new(rooms, path)
