extends Node

const tile_size = Vector2(32, 32)

func _enter_tree() -> void:
	RenderingServer.set_default_clear_color(Color.WHITE_SMOKE)
