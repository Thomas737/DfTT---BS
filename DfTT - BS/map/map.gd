class_name Map
extends Node2D

@export var pier_steam: Texture2D
@export var pier_modern: Texture2D

@export var intersection_handler: IntersectionHandler
@export var tile_generator: TileGenerator
@export var train_handler: TrainHandler
@export var river_handler: RiverHandler
@export var pause_menu: PauseMenu

var current_period: bool = true
var time_remaining: float = 550

func _process(delta: float) -> void:
	time_remaining -= delta
	%TimeRemaining.text = str(floor(time_remaining))
	if time_remaining < 0 and not Global.game_complete:
		Global.time_game_lost()

func _ready() -> void:
	%Fade.show()
	%ComputerStartup.play()
	%ComputerStartup.finished.connect(%ComputerAmbience.play)
	%ComputerStartup.finished.connect(_railway_ambience)
	get_tree().create_timer(100).timeout.connect(_tension_music)
	get_tree().create_tween().tween_property(%Fade, "modulate", Color(1,1,1,0), 5).set_trans(Tween.TRANS_CUBIC)
	Global.switch_period.connect(_prep_period_switch)

func _prep_period_switch(new_period: bool) -> void:
	%Instability.show()
	current_period = new_period
	%TrainSignal.position.x = -5000
	%Whistle.play()
	%TrackSound.play()
	get_tree().create_tween().tween_property(%TrainSignal, "position", Vector2(5000+1152, 360), 6)
	get_tree().create_timer(3).timeout.connect(_do_period_switch.bind(new_period))

func _do_period_switch(new_period: bool) -> void:
	%Instability.hide()
	tile_generator.set_new_period(new_period)
	river_handler.set_new_period(new_period)
	train_handler.set_new_period(new_period)
	if new_period:
		%Pier.texture = pier_modern
		%ComputerAmbience.play()
		%ModernRailway.play()
		%Industrial.stop()
	else:
		%ComputerAmbience.stop()
		%ComputerStartup.stop()
		%ModernRailway.stop()
		%Industrial.play()
		%Pier.texture = pier_steam

func fade_out() -> void:
	get_tree().create_tween().tween_property(%Fade, "modulate", Color(1,1,1,1), 3).set_trans(Tween.TRANS_CUBIC)
	get_tree().create_tween().tween_property(%ComputerAmbience, "volume_db", -80, 3).set_trans(Tween.TRANS_CUBIC)
	get_tree().create_tween().tween_property(%ModernRailway, "volume_db", -80, 3).set_trans(Tween.TRANS_CUBIC)
	get_tree().create_tween().tween_property(%Tension, "volume_db", -80, 3).set_trans(Tween.TRANS_CUBIC)

func _railway_ambience() -> void:
	if current_period and not get_tree().paused:
		%ModernRailway.play()
	var timer: SceneTreeTimer = get_tree().create_timer(250+randf_range(-50, 50))
	timer.timeout.connect(_railway_ambience)

func _tension_music() -> void:
	%Tension.play()
	get_tree().create_timer(150).timeout.connect(_tension_music)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("escape"):
			if intersection_handler.intersection_focus:
				intersection_handler.remove_intersection()
				tile_generator.show()
				train_handler.map_view()
				river_handler.show()
				%Pier.show()
				%PierSmallArrow.show()
				%HqStar.show()
				%BridgeFailed.show()
			else:
				get_tree().paused = true
				pause_menu.show()
		
		if event.is_action_released("space"):
			train_handler.focus_next_train()
