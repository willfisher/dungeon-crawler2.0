extends Area2D
class_name Attack

onready var character = get_parent()

export(int) var damage = 10

var can_attack = true

func _ready():
	assert(character is Character)
	set_physics_process(false)

func _physics_process(delta):
	var overlapping_areas = get_overlapping_areas()
	if not overlapping_areas:
		return
	
	for area in overlapping_areas:
		if area is Hitbox and not is_owner(area):
			area.take_damage(damage)
			set_physics_process(false)

func is_owner(node):
	return node.get_parent().get_path() == character.get_path()

func _on_attack():
	if can_attack:
		set_physics_process(true)
		can_attack = false
	
func _on_attack_finished():
	set_physics_process(false)
	can_attack = true
