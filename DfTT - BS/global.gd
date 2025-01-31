extends Node

var starting_switches: Array[Switch] = []

const tile_size = Vector2(32, 32)
const water = Color(85.0/256, 106.0/256, 151.0/256)

func _enter_tree() -> void:
	RenderingServer.set_default_clear_color(water)
