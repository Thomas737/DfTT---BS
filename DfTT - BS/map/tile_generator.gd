class_name TileGenerator
extends Node2D

const tile_preload = preload("res://map/tile/tile.tscn")

const width = 24
const height = 24

@export var intersection_handler: IntersectionHandler
@export var train_handler: TrainHandler
@export var river_handler: RiverHandler

@export_category("Districts")
@export var new_to_old: Dictionary
var old_to_new: Dictionary

@export var city1: DistrictResource
@export var city2: DistrictResource
@export var city3: DistrictResource
@export var forest_district: DistrictResource
@export var rural_district: DistrictResource
@export var beach_district: DistrictResource

@export_category("Noise Channels")
@export var city_noise: FastNoiseLite
@export var rural_noise: FastNoiseLite

var starting_switches: Array[Switch]
var player_starting_switch: Switch

func _ready() -> void:
	for key: DistrictResource in new_to_old:
		old_to_new[new_to_old[key]] = key
	
	city_noise.seed = randi()
	
	var grid_map: Dictionary = setup_grid_map()
	setup_railways(grid_map)
	setup_terrain(grid_map)
	
	for tile: Tile in grid_map.values():
		add_child(tile)

func set_new_period(new_period: bool) -> void:
	var grid_map: Dictionary = {}
	
	for tile: Tile in get_children():
		grid_map[tile.grid_position] = tile
	
	for location: Vector2 in grid_map:
		var tile: Tile = grid_map[location]
		var right_tile: Tile = grid_map.get(location+Vector2.RIGHT)
		var right_district: DistrictResource = null
		if right_tile:
			right_district = right_tile.district
		
		if new_period:
			tile.set_district(old_to_new.get(tile.district), right_district)
		else:
			tile.set_district(new_to_old.get(tile.district), right_district)

func setup_grid_map() -> Dictionary:
	var grid_map: Dictionary = {}
	
	for x: int in range(-10, width+10):
		for y: int in range(-10, height+10):
			var new_tile: Tile = tile_preload.instantiate()
			new_tile.grid_position = Vector2(x, y)
			grid_map[Vector2(x, y)] = new_tile
			new_tile.position = Vector2(x, y) * Global.tile_size
			new_tile.construct_intersection.connect(_intersection_display_requested)
	
	return grid_map

func setup_railways(grid_map: Dictionary) -> void:
	setup_edge_railway(grid_map)
	setup_vertical_routes(grid_map)
	
	connect_along_path(grid_map[Vector2(width/2, 0)], grid_map[Vector2(width/2, -10)], grid_map)
	var starting_tile: Tile = grid_map[Vector2(width/2, -10)]
	player_starting_switch = starting_tile.switch_handler.create_new_starting_switch(Vector2(width/2, -11))

func setup_terrain(grid_map: Dictionary) -> void:
	for location: Vector2 in grid_map:
		var city_value: float = (len(grid_map[location].switch_handler.get_switches())-4)/7 + city_noise.get_noise_2dv(location)
		if city_value > 0.3:
			grid_map[location].set_district(city1)
		elif city_value > 0.25:
			grid_map[location].set_district(city2)
		elif city_value > 0.15:
			grid_map[location].set_district(city3)
		if city_value > 0.15:
			continue
		
		var rural_value: float = rural_noise.get_noise_2dv(location)
		if rural_value > 0:
			grid_map[location].set_district(rural_district)
			continue
		
		grid_map[location].set_district(forest_district)
	
	for location: Vector2 in grid_map:
		if location.x == -5:
			grid_map[location].set_district(beach_district, grid_map[location+Vector2.RIGHT].district)
	for location: Vector2 in grid_map:
		if location.x == -6:
			grid_map[location].set_district(beach_district, grid_map[location+Vector2.RIGHT].district)
		if location.x < -6:
			grid_map[location].set_district(null)

func setup_edge_railway(grid_map: Dictionary) -> void:
	for y: int in [0, height-1]:
		for x: int in range(width-1):
			if y == 0 and x == 10:
				continue
			connect_switches(grid_map[Vector2(x, y)], grid_map[Vector2(x+1, y)])
	
	for x in range(-10, 0):
		connect_switches(grid_map[Vector2(x, 0)], grid_map[Vector2(x+1, 0)])
	for x in range(-10, -3):
		connect_switches(grid_map[Vector2(x, 3)], grid_map[Vector2(x+1, 3)])
	var end_tile: Tile = grid_map[Vector2(-7, 0)]
	end_tile.switch_handler.set_win_switch(Vector2.LEFT)
	end_tile = grid_map[Vector2(-7, 3)]
	end_tile.switch_handler.set_win_switch(Vector2.LEFT)
	
	for y in range(3):
		connect_switches(grid_map[Vector2(-3, y)], grid_map[Vector2(-3, y+1)])

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
		random_vectors += [Vector2(x, y1)] #, Vector2(x, y2)]
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
		
		# DO NOT FIX THIS BUG - it generates interesting rail-routes
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
		assert(false, "Uhh you can't connect switches to the same tile lmao")
	
	first_tile.switch_handler.create_new_switch(second_tile.switch_handler)
	second_tile.switch_handler.create_new_switch(first_tile.switch_handler)
	first_tile.connect_to(second_tile)
	second_tile.connect_to(first_tile)

func check_connected_tiles(first_tile: Tile, second_tile: Tile) -> bool:
	return first_tile in second_tile.connected_tiles

func _intersection_display_requested(tile: Tile) -> void:
	if not %MainCamera.ready_for_intersection:
		return
	
	intersection_handler.generate_intersection(tile)
	train_handler.intersection_view()
	river_handler.hide()
	%Pier.hide()
	hide()
	%PierSmallArrow.hide()
	%HqStar.hide()
	%BridgeFailed.hide()
	%MainCamera.tutorial_camera = false
