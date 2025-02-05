extends Node

signal switch_period(modern: bool)

# Modern - true    ;    Old - false
var current_period: bool = true

var starting_switches: Array[Switch] = []
var lost_trains: int = 0
var station_points: int = 0

const tile_size = Vector2(32, 32)
const water = Color(85.0/256, 106.0/256, 151.0/256)

func _enter_tree() -> void:
	RenderingServer.set_default_clear_color(water)

func game_start() -> void:
	lost_trains = 0
	station_points = 0
	get_tree().change_scene_to_file("res://map/map.tscn")
	get_tree().create_timer(100).timeout.connect(_switch_period)

func _switch_period() -> void:
	current_period = not current_period
	switch_period.emit(current_period)
	get_tree().create_timer(160).timeout.connect(_switch_period)

func game_won(train: Train) -> void:
	if train.player_train:
		train.get_parent().get_parent().fade_out()
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://menus/win_menu.tscn")
	else:
		train.fade_and_delete()

func train_reached_station(train: Train, tile: Tile) -> void:
	train.fade_and_delete()
	if tile:
		station_points += tile.district.station_points
	else:
		station_points += 12

func train_lost(train: Train) -> void:
	train.fade_and_delete()
	lost_trains += 1

func game_lost(train: Train) -> void:
	train.fade_and_delete()
	train.get_parent().get_parent().fade_out()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://cutscenes/game_lost/game_lost.tscn")

func time_game_lost() -> void:
	get_tree().current_scene.fade_out()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://cutscenes/game_lost/game_lost.tscn")
