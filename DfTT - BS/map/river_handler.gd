class_name RiverHandler
extends Node2D

const river_preload = preload("res://map/river/river.tscn")

enum {LEFT, RIGHT}

const left_most = 11
const right_most = 12
const height = 23

func _ready() -> void:
	setup_bridges()
	
	var current_side: int = LEFT
	for y in range(1, height):
		if randf() > 0.8 or (y == height-1 and current_side == LEFT):
			if current_side == LEFT:
				new_river(-1, Vector2(left_most, y), false, true)
				new_river(1, Vector2(right_most, y))
				current_side = RIGHT
			else:
				new_river(1, Vector2(right_most, y), false, true)
				new_river(-1, Vector2(left_most, y))
				current_side = LEFT
		else:
			if current_side == LEFT:
				new_river(0, Vector2(left_most, y))
			else:
				new_river(0, Vector2(right_most, y))

func setup_bridges() -> void:
	new_river(0, Vector2(left_most, 0), true)
	for y in range(-10, 0):
		new_river(0, Vector2(left_most, y))
	
	new_river(0, Vector2(right_most, height), true)
	for y in range(height+1, height+10):
		new_river(0, Vector2(right_most, y))

func new_river(direction: int, location: Vector2, crossing: bool = false, flipped: bool = false) -> void:
	var new_river: River = river_preload.instantiate()
	new_river.set_direction(direction, crossing, flipped)
	new_river.position = location * Global.tile_size
	add_child(new_river)
