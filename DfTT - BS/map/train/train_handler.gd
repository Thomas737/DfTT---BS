class_name TrainHandler
extends Node2D

const train_preload = preload("res://map/train/train.tscn") 

var last_focussed_train: int = -1

@export var tile_generator: TileGenerator
@export var intersection_handler: IntersectionHandler
@export var main_camera: MainCamera

@export_category("Train Types")
@export var player_train: TrainResource
@export var cargo_train: TrainResource

func _ready() -> void:
	var new_train: Train = train_preload.instantiate()
	new_train.current_switch = tile_generator.player_starting_switch
	new_train.train_resource = player_train
	new_train.player_train = true
	add_child(new_train)

func random_create_train() -> void:
	var new_train: Train = train_preload.instantiate()
	new_train.current_switch = Global.starting_switches.pick_random()
	new_train.train_resource = cargo_train
	new_train.timing_adjustment = 0.3
	add_child(new_train)

func map_view() -> void:
	for train: Train in get_children():
		train.set_view(0)

func intersection_view() -> void:
	for train: Train in get_children():
		train.set_view(1)

func focus_next_train() -> void:
	if not get_children():
		return
	
	last_focussed_train += 1
	if last_focussed_train >= len(get_children()):
		last_focussed_train = 0
	main_camera.position = get_children()[last_focussed_train].map_icon.global_position
