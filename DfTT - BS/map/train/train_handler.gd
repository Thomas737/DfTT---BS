class_name TrainHandler
extends Node2D

const train_preload = preload("res://map/train/train.tscn") 

@export var tile_generator: TileGenerator


func _ready() -> void:
	var new_train: Train = train_preload.instantiate()
	new_train.current_switch = tile_generator.player_starting_switch
	add_child(new_train)
