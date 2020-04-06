extends Node2D
class_name AnimatedCharacter

signal attack_finished

onready var animated_sprite : AnimatedSprite = get_node("AnimatedSprite")

func _on_state_changed(state):
	match state:
		Character.STATE.idle:
			animated_sprite.play("idle")
		Character.STATE.walk:
			animated_sprite.play("walk")
		Character.STATE.attack:
			animated_sprite.play("attack")
		Character.STATE.dead:
			animated_sprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == "attack":
		emit_signal("attack_finished")
