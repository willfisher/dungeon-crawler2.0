extends Node2D

# Dungeon generation
var generator = preload("res://src/dungeon generation/generators/PhysicsGeneration.gd").new()
var tiler = preload("res://src/dungeon generation/tilers/DefaultTiler.gd").new(
	StaticStyles.floor_tile,
	StaticStyles.wall_tile
)
var decorator = preload("res://src/dungeon generation/decorators/Decorator.gd").new(
	[[StaticStyles.default_room_1, 0], [StaticStyles.default_room_2, 1]]
)
onready var tile_map_package = TileMapPackage.new(
	$Floor,
	$FloorDecor,
	$Shadows,
	$Props
)

func _ready():
	yield(get_tree(), "idle_frame")
	var dungeon = yield(generator.generate(get_tree()), "completed")
	tiler.tile(tile_map_package, dungeon)
	decorator.decorate(tile_map_package, dungeon.rooms)
	
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
