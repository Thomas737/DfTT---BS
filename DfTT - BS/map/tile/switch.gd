class_name Switch
extends Node2D

var on_tile: Tile
var direction: Vector2

var left_turn: Switch = null
var straight: Switch = null
var right_turn: Switch = null

@onready var left_path: Curve2D = %LeftPath.curve
@onready var straight_path: Curve2D = %StraightPath.curve
@onready var right_path: Curve2D = %RightPath.curve

var current_outbound: int = 0

func _ready() -> void:
	rotation = direction.angle()
	if not left_turn:
		%Left.hide()
	if not right_turn:
		%Right.hide()
	if not straight:
		%Straight.hide()

func get_outbound_path() -> Curve2D:
	return get_outbound_variant(right_path, left_path, straight_path)

func get_outbound_switch() -> Switch:
	return get_outbound_variant(right_turn, left_turn, straight)

func get_outbound_variant(right: Variant, left: Variant, str: Variant) -> Variant:
	if right_turn and current_outbound == 1:
		return right
	if left_turn and current_outbound == -1:
		return left
	if straight and current_outbound == 0:
		return str
	
	if straight:
		return str
	if right_turn:
		return right
	return left

func add_outbound_switches(outbound_switches: Array[Switch]) -> void:
	for outbound_switch: Switch in outbound_switches:
		add_outbound_switch(outbound_switch)

func add_outbound_switch(outbound_switch: Switch) -> void:
	if on_tile.grid_position - direction == outbound_switch.on_tile.grid_position:
		return
	if direction == outbound_switch.direction:
		straight = outbound_switch
	elif direction.angle_to(outbound_switch.direction) > 0:
		right_turn = outbound_switch
	elif direction.angle_to(outbound_switch.direction) < 0:
		left_turn = outbound_switch
	else:
		assert(false, "Switch direction error")
