extends Node

const clear_id = -1

const table_horizontal_id = 9
const table_sideways_id = 10

const chair_id = 7

const book_id = 13

const altar_single_id = 11

var altar = Monument.new(
	2, [[Vector2.ZERO, altar_single_id]], 0, 0
)

var table_chair_gold = Monument.new(
	3, [[Vector2.ZERO, table_horizontal_id], [Vector2(1,0), book_id], [Vector2(0,1), clear_id], [Vector2(1,1), clear_id], [Vector2(2,1), chair_id]],
	4, 4,
	[[false, false, false], [false, true, false], [false, false, false]],
	[[0,0,0],[0,1,0],[0,0,0]]
)

var default_room_1 = RoomStyle.new(
	.1, [
		SpawnableMonument.new(
			altar, 1, 2
		),
		SpawnableMonument.new(
			table_chair_gold, .1, 1
		)
	]
)
