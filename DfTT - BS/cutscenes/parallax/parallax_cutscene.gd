class_name ParallaxCutscene
extends Node2D

var track_speed: float = 0

func _ready() -> void:
	%Engine.play()
	get_tree().create_tween().tween_property(%Engine, "volume_db", -15, 7).set_trans(Tween.TRANS_LINEAR).finished.connect(_train_accellerating)

func _random_sparks() -> void:
	%WheelSparks.get_children().pick_random().emitting = true
	get_tree().create_timer(0.2 + randf()).timeout.connect(_random_sparks)

func _process(delta: float) -> void:
	%CloseClouds.scroll_offset.x += track_speed * delta * 0.15
	%FargroundClouds.scroll_offset.x += track_speed * delta * 0.1
	%Far.scroll_offset.x += track_speed * delta * 0.5
	%Pier.scroll_offset.x += track_speed * delta * 0.8
	%Track.scroll_offset.x += track_speed * delta
	%Water.position.x += track_speed * delta * 1.2
	%Close.scroll_offset.x += track_speed * delta * 1.2

func _train_accellerating() -> void:
	_random_sparks()
	%Music.play()
	%Hydraulics.play()
	%Tracks.play()
	%Light.frame = 1
	get_tree().create_tween().tween_property(%Tracks, "volume_db", -17, 10).set_trans(Tween.TRANS_LINEAR)
	get_tree().create_tween().tween_property(self, "track_speed", 150, 30).set_trans(Tween.TRANS_QUAD)
	get_tree().create_timer(55).timeout.connect(_brakes_failed)

func _brakes_failed() -> void:
	get_tree().create_tween().tween_property(%Engine, "volume_db", -10, 15).set_trans(Tween.TRANS_LINEAR)
	get_tree().create_tween().tween_property(%Tracks, "volume_db", -10, 10).set_trans(Tween.TRANS_LINEAR)
	get_tree().create_tween().tween_property(%Tracks, "pitch_scale", 1.5, 10)
	get_tree().create_tween().tween_property(self, "track_speed", 300, 20).set_trans(Tween.TRANS_QUAD)
