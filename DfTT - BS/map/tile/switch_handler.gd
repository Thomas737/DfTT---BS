class_name SwitchHandler
extends Node2D

const switch_preload = preload("res://map/tile/switch.tscn")

@export var on_tile: Tile

var all_outbound_switches: Array[Switch]

func _ready() -> void:
	if len(get_switches()) == 1:
		on_tile.connected_tiles[0].switch_handler.set_entrance_switch(on_tile.connected_tiles[0].grid_position - on_tile.grid_position)

func set_entrance_switch(direction: Vector2) -> void:
	for switch in get_switches():
		if switch.direction == direction:
			switch.set_starting_switch()
			Global.starting_switches.append(switch)

func set_win_switch(direction: Vector2) -> void:
	for switch in get_switches():
		if switch.direction == direction:
			switch.set_win_switch()
			switch.new_train.connect(Global.game_won)

func create_new_switch(from: SwitchHandler) -> void:
	var inbound_switch: Switch = switch_preload.instantiate()
	inbound_switch.on_tile = on_tile
	inbound_switch.direction = on_tile.grid_position - from.on_tile.grid_position
	
	inbound_switch.add_outbound_switches(all_outbound_switches)
	from.add_outbound_switch(inbound_switch)
	add_child(inbound_switch)

func create_new_starting_switch(from_tile: Vector2) -> Switch:
	var inbound_switch: Switch = switch_preload.instantiate()
	inbound_switch.on_tile = on_tile
	inbound_switch.direction = on_tile.grid_position - from_tile
	
	inbound_switch.add_outbound_switches(all_outbound_switches)
	add_child(inbound_switch)
	return inbound_switch

func add_outbound_switch(outbound_switch: Switch) -> void:
	all_outbound_switches.append(outbound_switch)
	for inbound_switch: Switch in get_children():
		inbound_switch.add_outbound_switch(outbound_switch)

func get_switches() -> Array[Switch]:
	var switches: Array[Switch] = []
	for switch: Switch in get_children():
		switches.append(switch)
	return switches
