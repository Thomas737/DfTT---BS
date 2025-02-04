class_name ParallaxCutscene
extends Node2D

var track_speed: float = 0
var cutscene_complete: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("space") and cutscene_complete:
			Global.game_start()

func _ready() -> void:
	%Engine.play()
	get_tree().create_tween().tween_property(%Engine, "volume_db", -15, 7).set_trans(Tween.TRANS_LINEAR).finished.connect(_train_accellerating)

func _random_sparks() -> void:
	%WheelSparks.get_children().pick_random().emitting = true
	get_tree().create_timer(0.2 + randf() + track_speed/500).timeout.connect(_random_sparks)

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
	get_tree().create_tween().tween_property(self, "track_speed", 500, 20).set_trans(Tween.TRANS_QUAD)
	get_tree().create_timer(74.5-55).timeout.connect(_cutscene_end)

func _cutscene_end() -> void:
	%BlackBackground.show()
	get_tree().create_timer(76.3-74.5).timeout.connect(_explosion)

func _explosion() -> void:
	get_tree().create_timer(1).timeout.connect(%Explosion.play)
	%Engine.volume_db = -80
	%Tracks.volume_db = -80
	await get_tree().create_timer(5).timeout
	get_tree().create_tween().tween_property(%DfttSign, "modulate", Color(1, 1, 1, 1), 2).finished.connect(_letter)

func _letter() -> void:
	await get_tree().create_timer(4).timeout
	%DfttLetter.show()
	%DfttSign.hide()
	%CutsceneCamera.position = %Target.position
	get_tree().create_tween().tween_property(%CutsceneCamera, "zoom", %Target.zoom, 1).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(10).timeout
	get_tree().create_tween().tween_property(%Spacepopup, "modulate", Color(1, 1, 1, 1), 0.1)
	cutscene_complete = true
