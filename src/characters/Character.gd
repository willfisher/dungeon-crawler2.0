extends KinematicBody2D
class_name Character

var velocity = Vector2()
export(float) var mass = 2

signal state_changed
enum STATE {
	idle,
	walk,
	attack,
	dead
}
signal direction_changed
enum DIRECTION {
	left,
	right
}
var state = null setget set_state
var direction = DIRECTION.right setget set_direction

enum CHARACTER_CLASS {
	gold_knight,
	ranger,
	skeleton
}
var character_class = CHARACTER_CLASS.gold_knight setget set_class
enum CHARACTER_GENDER {
	male,
	female
}
var character_gender = CHARACTER_GENDER.male setget set_gender


func _ready():
	set_state(STATE.idle)

func _physics_process(delta):
	if state == STATE.dead or state == STATE.attack:
		return
	
	if velocity.length() > 0:
		set_state(STATE.walk)
	else:
		set_state(STATE.idle)
	if velocity.x > 0:
		set_direction(DIRECTION.right)
	elif velocity.x < 0:
		set_direction(DIRECTION.left)
	
	move_and_slide(velocity)

func _on_death():
	set_state(STATE.dead)
	for n in get_children():
		if n.is_in_group("keep_on_death"):
			continue
		remove_child(n)
		n.queue_free()
	
func _on_attack():
	set_state(STATE.attack)
	
func _on_attack_finished():
	set_state(STATE.idle)

func set_state(new_state):
	if new_state == state:
		return
	state = new_state
	emit_signal("state_changed", state)
	
func set_direction(new_direction):
	if new_direction == direction:
		return
	direction = new_direction
	scale.x *= -1
	for n in get_children():
		if n.is_in_group("keep_scale") and n is Node2D:
			n.scale.x *= -1
	emit_signal("direction_changed", direction)

func set_class(_character_class):
	character_class = _character_class
	update_sprite()

func set_gender(_character_gender):
	character_gender = _character_gender
	update_sprite()

func update_sprite():
	if has_node("AnimatedCharacter"):
		if get_node("AnimatedCharacter").has_node("AnimatedSprite"):
			var animated_sprite : AnimatedSprite = get_node("AnimatedCharacter").get_node("AnimatedSprite")
			match character_class:
				CHARACTER_CLASS.gold_knight:
					match character_gender:
						CHARACTER_GENDER.male:
							animated_sprite.set_sprite_frames(preload("res://assets/sprites/characters/sprite frames/gold knight.tres"))
				CHARACTER_CLASS.ranger:
					match character_gender:
						CHARACTER_GENDER.male:
							animated_sprite.set_sprite_frames(preload("res://assets/sprites/characters/sprite frames/ranger.tres"))
				CHARACTER_CLASS.skeleton:
					animated_sprite.set_sprite_frames(preload("res://assets/sprites/characters/sprite frames/skeleton.tres"))
