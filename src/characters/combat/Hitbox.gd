extends Area2D
class_name Hitbox

signal take_damage

func take_damage(damage):
	emit_signal("take_damage", damage)
