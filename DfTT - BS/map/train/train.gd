class_name Train
extends Node2D

signal on_destroyed

const carriage_offsets = 66

@onready var carriage_path_followers: Array[PathFollow2D] = [%Carriage3, %Carriage2, %Carriage, %Engine]
@onready var map_icon: Sprite2D = %MapIcon
var close_view: bool

var train_resource: TrainResource
var modern: bool = true

var current_switch: Switch = null
var previous_switch: Switch = null

var player_train: bool = false
var timing_adjustment: float = 0

func _ready() -> void:
	%EngineSprite.texture = train_resource.engine
	%CarriageSprite.texture = train_resource.carriage
	%CarriageSprite2.texture = train_resource.carriage
	%CarriageSprite3.texture = train_resource.carriage
	map_icon.texture = train_resource.map_texture

func _process(delta: float) -> void:
	%Steam.emitting = not modern
	%Steam2.emitting = not modern
	%Steam3.emitting = not modern
	%SmallSteam.emitting = not modern
	if %MapRepresentation.progress_ratio >= 1 or not %CurrentTrack.curve:
		get_next_track()
	
	%MapRepresentation.progress += train_resource.speed * delta
	for carriage in carriage_path_followers:
		carriage.progress += train_resource.speed * delta * 20
	if carriage_path_followers[2].progress_ratio == 1:
		%TrainPassing.stop()
		%CurrentIntersection.curve = null
	
	if %Carriage2.progress_ratio > 0 and not %TrainPassing.playing:
		%TrainPassing.play(0)

func set_new_period(new_period: bool) -> void:
	modern = new_period
	if new_period:
		%EngineSprite.texture = train_resource.engine
		%MapIcon.texture = train_resource.map_texture
	if not new_period:
		%EngineSprite.texture = train_resource.alternate_engine
		%MapIcon.texture = train_resource.alternate_mapmode
	
	if new_period and not player_train:
		%CarriageSprite.texture = train_resource.carriage
		%CarriageSprite2.texture = train_resource.carriage
		%CarriageSprite3.texture = train_resource.carriage
	if not new_period and not player_train:
		%CarriageSprite.texture = train_resource.alternate_carriage
		%CarriageSprite2.texture = train_resource.alternate_carriage
		%CarriageSprite3.texture = train_resource.alternate_carriage

func get_next_track() -> void:
	if previous_switch:
		previous_switch.outbound_trains.erase(self)
	previous_switch = current_switch
	current_switch.outbound_trains.append(self)
	current_switch.inbound_trains.erase(self)
	var new_curve: Curve2D = current_switch.get_outbound_path()
	%CurrentTrack.position = current_switch.global_position
	%CurrentTrack.rotation = current_switch.global_rotation
	%CurrentTrack.curve = new_curve
	%MapRepresentation.progress = 0
	current_switch = current_switch.get_outbound_switch()
	if not current_switch:
		if player_train:
			Global.game_lost(self)
			return
		Global.train_reached_station(self, previous_switch.on_tile)
		return
	current_switch.inbound_trains.append(self)
	current_switch.new_train.emit(self)
	previous_switch.train_outbound.emit(self, previous_switch.get_outbound_direction())

func fade_and_delete() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(queue_free)
	on_destroyed.emit()

func setup_close_view(curve: Curve2D, outbound: bool, angle: float, account_inbound_progress: float = 0) -> void:
	%CurrentIntersection.show()
	%CurrentIntersection.curve = curve
	%CurrentIntersection.rotation = angle
	
	var distance_along: float = 0.0
	if outbound:
		distance_along = 779.0 + %MapRepresentation.progress_ratio * (1600.0-779.0)
	else:
		distance_along = 800.0 - (800.0-66*3)*(1-%MapRepresentation.progress_ratio)
	
	
	var relative_progress: int = -3
	for carriage in carriage_path_followers:
		carriage.progress = max(0, relative_progress * carriage_offsets + distance_along)
		relative_progress += 1

func get_map_representation() -> PathFollow2D:
	return %MapRepresentation

func setup_new_close_path(curve: Curve2D) -> void:
	%CurrentIntersection.curve = curve

func set_view(value: int) -> void:
	if value == 0:
		%CurrentIntersection.hide()
		%CurrentIntersection.curve = null
		%TrainPassing.stop()
		%CurrentTrack.show()
	else:
		%CurrentTrack.hide()

func _on_collision_area_entered(area: Area2D) -> void:
	if player_train:
		Global.game_lost(self)
		return
	Global.train_lost(self)
