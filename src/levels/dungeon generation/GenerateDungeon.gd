extends Node2D

# Dungeon generation
var generator = preload("res://src/levels/dungeon generation/generators/PhysicsGeneration.gd").new()
var tiler = preload("res://src/levels/dungeon generation/tilers/DefaultTiler.gd").new()

func _ready():
	yield(get_tree(), "idle_frame")
	var dungeon = yield(generator.generate(get_tree()), "completed")
	tiler.tile($Floor, dungeon)
	
	instantiate_player(dungeon)


# Add player to scene
var player = preload("res://src/characters/player/Player.tscn")

func instantiate_player(dungeon):
	var _player = player.instance()
	_player.character_class = Character.CHARACTER_CLASS.gold_knight
	
	_player.global_position = $Floor.map_to_world(dungeon.spawn_point())
	
	var camera = Camera2D.new()
	camera.current = true
	camera.add_to_group("keep_on_death")
	_player.add_child(camera)
	
	$Props.add_child(_player)
