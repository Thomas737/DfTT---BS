class_name TrainHandler
extends Node2D

const train_preload = preload("res://map/train/train.tscn") 

@export var tile_generator: TileGenerator
@export var intersection_handler: IntersectionHandler

func _ready() -> void:
	var new_train: Train = train_preload.instantiate()
	new_train.current_switch = tile_generator.player_starting_switch
	new_train.new_switch.connect(_train_changed_switch)
	add_child(new_train)

func _train_changed_switch(train: Train) -> void:
	intersection_handler.add_new_train(train)
