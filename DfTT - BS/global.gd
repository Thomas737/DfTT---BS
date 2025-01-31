extends Node

var starting_switches: Array[Switch] = []
var lost_trains: int = 0

const tile_size = Vector2(32, 32)
const water = Color(85.0/256, 106.0/256, 151.0/256)

func _enter_tree() -> void:
	RenderingServer.set_default_clear_color(water)

func game_won(train: Train) -> void:
	if train.player_train:
		print("YOU WIN")
		get_tree().change_scene_to_file("res://cutscenes/scrolling_ground.tscn")
	else:
		train.fade_and_delete()

func train_lost(train: Train) -> void:
	lost_trains += 1
	print("TRAIN LOST")

func game_lost(train: Train) -> void:
	print("YOU LOSE")
