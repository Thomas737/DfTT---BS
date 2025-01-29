class_name Tile
extends Node2D

signal construct_intersection(tile: Tile)

@export var switch_handler: SwitchHandler

var district: DistrictResource
var grid_position: Vector2

var mouse_hovering: bool = false
var scale_complete: bool = true
var scale_tween: Tween
var connected_tiles: Array[Tile] = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not is_turn_intersection():
		return
	
	if not scale_complete and scale_tween:
		scale_tween.kill()
	
	if mouse_hovering and not scale_complete:
		scale_tween = get_tree().create_tween()
		scale_tween.tween_property(self, "scale", Vector2.ONE+Vector2.ONE/3, 0.2).set_trans(Tween.TRANS_CUBIC)
		top_level = true
	if not mouse_hovering and not scale_complete:
		scale_tween = get_tree().create_tween()
		scale_tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_CUBIC)
		scale_tween.finished.connect(_on_scaled_down)
	scale_complete = true

func _on_scaled_down() -> void:
	top_level = false

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
	get_tree().call_group("tiles", "_on_mouse_exited")
	mouse_hovering = true
	scale_complete = false

func _on_mouse_exited() -> void:
	mouse_hovering = false
	scale_complete = false
