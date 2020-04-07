class_name SpawnableMonument

var monument : Monument
var probability : float
var max_per_room : int

func _init(monument, probability, max_per_room = -1):
	self.monument = monument
	self.probability = probability
	self.max_per_room = max_per_room
