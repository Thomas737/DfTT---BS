class_name Tile
extends Node2D

signal construct_intersection(tile: Tile)

@export var switch_handler: SwitchHandler

var district: DistrictResource
var grid_position: Vector2

var mouse_hovering: bool = false
var connected_tiles: Array[Tile] = []

func _ready() -> void:
	pass

func is_turn_intersection() -> bool:
	return len(switch_handler.get_switches()) > 2

func set_district(district: DistrictResource) -> void:
	%District.texture = district.textures.pick_random()

func connect_to(other_tile: Tile) -> void:
	connected_tiles.append(other_tile)

func _on_mouse_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("select") and is_turn_intersection():
			construct_intersection.emit(self)

# TODO - Hover visuals
func _on_mouse_entered() -> void:
	mouse_hovering = true

func _on_mouse_exited() -> void:
	mouse_hovering = false
