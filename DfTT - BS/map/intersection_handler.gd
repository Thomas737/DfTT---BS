class_name IntersectionHandler
extends Node2D

const intersection_preload = preload("res://intersection/intersection.tscn")

var intersection_focus: bool = false

func generate_intersection(tile: Tile) -> void:
	if intersection_focus:
		return
	
	var intersection: Intersection = intersection_preload.instantiate()
	intersection.setup_track(tile.switch_handler)
	intersection.setup_district(tile.district)
	add_child(intersection)
	
	intersection_focus = true

func remove_intersection() -> void:
	intersection_focus = false
	get_child(0).queue_free()
