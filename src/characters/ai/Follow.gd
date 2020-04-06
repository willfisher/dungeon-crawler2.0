extends Node
class_name Follow

onready var parent = get_parent()
var target = null

const DISTANCE_THRESHOLD = 15.0

export var max_speed = 75

func _ready():
	assert(parent is Character)

func _physics_process(delta):
	if target == null:
		parent.velocity = Vector2.ZERO
		return
	var target_global_position : Vector2 = target.global_position
	
	if parent.global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD:
		parent.velocity = Vector2.ZERO
		return
	
	parent.velocity = Steering.follow(
		parent.velocity,
		parent.global_position,
		target_global_position,
		max_speed
	)

func set_target(body):
	target = body

func remove_target(body):
	if target == body:
		target = null
