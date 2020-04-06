extends Node

var player = preload("res://src/characters/player/Player.tscn")

func _instantiate_player(dungeon):
	var _player = player.instance()
	_player.character_class = Character.CHARACTER_CLASS.gold_knight
	
	_player.global_position = get_parent().get_node("Floor").map_to_world(dungeon.spawn_point())
	
	var camera = Camera2D.new()
	camera.current = true
	camera.add_to_group("keep_on_death")
	_player.add_child(camera)
	
	add_child(_player)
