extends Node
class_name SimpleAttack

signal attack

onready var parent = get_parent()
var target = null

export(float) var attack_distance = 15.0

func _onready():
	assert(parent is Node2D)
	set_physics_process(false)

func _physics_process(delta):
	if target == null:
		return
	if parent.global_position.distance_to(target.global_position) < attack_distance:
		emit_signal("attack")

func set_target(body):
	if not body is Node2D:
		return
	target = body
	set_physics_process(true)

func remove_target(body):
	if target == body:
		target = null
		set_physics_process(false)
