class_name Map
extends Node2D

@export var intersection_handler: IntersectionHandler
@export var tile_generator: TileGenerator
@export var train_handler: TrainHandler
@export var river_handler: RiverHandler

func _ready() -> void:
	%ComputerStartup.play()
	%ComputerStartup.finished.connect(%ComputerAmbience.play)
	%ComputerStartup.finished.connect(_railway_ambience)

func _railway_ambience() -> void:
	%ModernRailway.play()
	var timer: SceneTreeTimer = get_tree().create_timer(250+randf_range(-50, 50))
	timer.timeout.connect(_railway_ambience)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("escape"):
			if intersection_handler.intersection_focus:
				intersection_handler.remove_intersection()
				tile_generator.show()
				train_handler.map_view()
				river_handler.show()
				%Pier.show()
		
		if event.is_action_released("space"):
			train_handler.focus_next_train()
