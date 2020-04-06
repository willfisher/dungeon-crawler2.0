extends Node
class_name Controllable

signal attack

onready var parent = get_parent()
export(float) var speed = 100

func _ready():
	assert(parent is Character)

func _input(event):
	if event.is_action_pressed("attack"):
		if parent.state in [Character.STATE.attack, Character.STATE.dead]:
			return
		emit_signal("attack")

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		parent.velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		parent.velocity.x = -1
	else:
		parent.velocity.x = 0
	
	if Input.is_action_pressed("ui_up"):
		parent.velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		parent.velocity.y = 1
	else:
		parent.velocity.y = 0
	
	parent.velocity = speed * parent.velocity.normalized()
