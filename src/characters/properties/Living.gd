extends Node
class_name Living

signal max_health_updated
signal health_updated
signal died

export(int) var max_health = 100 setget set_max_health
export(int) var health = 100 setget set_health

func _ready():
	set_max_health(max_health)
	set_health(health)

func set_health(new_health):
	new_health = clamp(new_health, 0, max_health)
	emit_signal("health_updated", new_health, new_health - health)
	if new_health == 0 and health != 0:
		emit_signal("died")
	health = new_health

func set_max_health(new_max_health):
	max_health = new_max_health
	emit_signal("max_health_updated", max_health)

func _on_take_damage(damage):
	set_health(health - damage)
