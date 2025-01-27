class_name Map
extends Node2D

@export var intersection_handler: IntersectionHandler
@export var tile_generator: TileGenerator

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("escape"):
			if intersection_handler.intersection_focus:
				intersection_handler.remove_intersection()
				tile_generator.show()
