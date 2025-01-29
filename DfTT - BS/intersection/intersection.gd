class_name Intersection
extends Node2D

const intersection_switch_preload = preload("res://intersection/intersection_switch.tscn")

func _ready() -> void:
	pass

func setup_track(switch_handler: SwitchHandler) -> void:
	for switch: Switch in switch_handler.get_switches():
		var intersection_switch: IntersectionSwitch = intersection_switch_preload.instantiate()
		add_child(intersection_switch)
		intersection_switch.setup_switch(switch)

func setup_district(district: DistrictResource) -> void:
	pass

func has_switch(switch: Switch) -> bool:
	# TODO
	return false
