class_name TileGenerator
extends Node2D

const tile_preload = preload("res://map/tile/tile.tscn")

const width = 32
const height = 32

@export var intersection_handler: IntersectionHandler

var starting_switches: Array[Switch]
var player_starting_switch: Switch

func _ready() -> void:
	var grid_map: Dictionary = {}
	
	for x: int in range(width):
		for y: int in range(height):
			var new_tile: Tile = tile_preload.instantiate()
			new_tile.grid_position = Vector2(x, y)
			grid_map[Vector2(x, y)] = new_tile
			new_tile.position = Vector2(x, y) * Global.tile_size
			new_tile.construct_intersection.connect(_intersection_display_requested)
			add_child(new_tile)
	
	setup_edge_railway(grid_map)
	setup_vertical_routes(grid_map)
	
	for upper_starting_tile: Vector2 in [Vector2(floor(width/2), 0)]:
		var tile: Tile = grid_map[upper_starting_tile]
		player_starting_switch = tile.switch_handler.create_new_starting_switch(upper_starting_tile+Vector2.UP)

func setup_edge_railway(grid_map: Dictionary) -> void:
	for y: int in [0, height-1]:
		for x: int in range(width-1):
			connect_switches(grid_map[Vector2(x, y)], grid_map[Vector2(x+1, y)])

func setup_vertical_routes(grid_map: Dictionary) -> void:
	var left_side: Array[int] = []
	var right_side: Array[int] = []
	for x in range(width/2-1):
		left_side.append(x)
	for x in range(width/2+1, width):
		right_side.append(x)
	var random_left_side: Array[Vector2] = randomize_vertical_sides(left_side)
	var random_right_side: Array[Vector2] = randomize_vertical_sides(right_side)
	
	var left_edges: Array[Vector2] = []
	var right_edges: Array[Vector2] = []
	for i in range(3):
		left_edges.append(Vector2(left_side.pop_at(randi_range(0, len(left_side)-1)), 0))
		left_edges.append(Vector2(left_side.pop_at(randi_range(0, len(left_side)-1)), height-1))
		right_edges.append(Vector2(right_side.pop_at(randi_range(0, len(right_side)-1)), 0))
		right_edges.append(Vector2(right_side.pop_at(randi_range(0, len(right_side)-1)), height-1))
	
	randomize_routes(random_left_side, left_edges, grid_map)
	randomize_routes(random_right_side, right_edges, grid_map)

func randomize_vertical_sides(side: Array[int]) -> Array[Vector2]:
	var random_vectors: Array[Vector2] = []
	for x in side:
		var y1: int = 0
		var y2: int = 0
		while y1 == y2:
			y1 = randi_range(0, height-1)
			y2 = randi_range(0, height-1)
		random_vectors += [Vector2(x, y1), Vector2(x, y2)]
	return random_vectors

func randomize_routes(side: Array[Vector2], edges: Array[Vector2], grid_map: Dictionary) -> void:
	var index: int = 0
	for vector: Vector2 in side:
		var other_vector1: Vector2 = side[randi_range(0, index)]
		var other_vector2: Vector2 = side[randi_range(index, len(side)-1)]
		connect_along_path(grid_map[vector], grid_map[other_vector1], grid_map)
		connect_along_path(grid_map[vector], grid_map[other_vector2], grid_map)
		
		index += 1
	
	for edge in edges:
		connect_along_path(grid_map[side.pick_random()], grid_map[edge], grid_map)

func connect_along_path(first_tile: Tile, second_tile: Tile, grid_map: Dictionary) -> void:
	var path: Vector2 = second_tile.grid_position - first_tile.grid_position
	while not (path.x == 0 and path.y == 0):
		var prev_path: Vector2 = path
		if randi_range(0, 1) and path.x != 0:
			path.x = (abs(path.x)-1)*sign(path.x)
		else:
			path.y = (abs(path.y)-1)*sign(path.y)
		if prev_path == path:
			return
		if not check_connected_tiles(grid_map[first_tile.grid_position+path], grid_map[first_tile.grid_position+prev_path]):
			connect_switches(grid_map[first_tile.grid_position+path], grid_map[first_tile.grid_position+prev_path])

func connect_switches(first_tile: Tile, second_tile: Tile) -> void:
	if first_tile.grid_position == second_tile.grid_position:
		assert(false, "hmmmmm")
	
	first_tile.switch_handler.create_new_switch(second_tile.switch_handler)
	second_tile.switch_handler.create_new_switch(first_tile.switch_handler)
	first_tile.connect_to(second_tile)
	second_tile.connect_to(first_tile)

func check_connected_tiles(first_tile: Tile, second_tile: Tile) -> bool:
	return first_tile in second_tile.connected_tiles

func _intersection_display_requested(tile: Tile) -> void:
	intersection_handler.generate_intersection(tile)
