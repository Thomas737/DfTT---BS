class_name TrainHandler
extends Node2D

const train_preload = preload("res://map/train/train.tscn") 

@export var tile_generator: TileGenerator
@export var intersection_handler: IntersectionHandler

@export_category("Train Types")
@export var player_train: TrainResource
@export var cargo_train: TrainResource

func _ready() -> void:
	var new_train: Train = train_preload.instantiate()
	new_train.current_switch = tile_generator.player_starting_switch
	new_train.train_resource = player_train
	new_train.player_train = true
	add_child(new_train)
	random_create_train()
	random_create_train()

func random_create_train() -> void:
	var new_train: Train = train_preload.instantiate()
	new_train.current_switch = Global.starting_switches.pick_random()
	new_train.train_resource = cargo_train
	new_train.timing_adjustment = 1
	add_child(new_train)

func map_view() -> void:
	for train: Train in get_children():
		train.set_view(0)

func intersection_view() -> void:
	for train: Train in get_children():
		train.set_view(1)
