class_name GameWon
extends Node2D

var train_speed: float = 0
var end_of_track: bool = false
var ready_to_return_to_menu: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("space") and ready_to_return_to_menu:
			queue_free()

func _ready() -> void:
	%Score.text = "Station Points:		 " + str(Global.station_points)
	%Crashes.text = "Crashes:				 " + str(round(Global.lost_trains/2))
	%SideOn.hide()
	%TopDown.show()
	%Tracks.play()
	%Engine.play()
	get_tree().create_tween().tween_property(self, "train_speed", 50, 7).finished.connect(print.bind("here"))
	get_tree().create_timer(17).timeout.connect(_cover)
	get_tree().create_timer(22).timeout.connect(_credits)

func _process(delta: float) -> void:
	%TrainIcon.position.x -= train_speed * delta
	if %TrainIcon.position.x < -90 and not end_of_track:
		end_of_track = true
		get_tree().create_tween().tween_property(%Tracks, "volume_db", -80, 1).set_trans(Tween.TRANS_EXPO)
		get_tree().create_tween().tween_property(%TrainIcon, "scale", Vector2(0.6,0.6), 4).set_trans(Tween.TRANS_CUBIC).finished.connect(_splashdown)
		get_tree().create_tween().tween_property(%Engine, "pitch_scale", 1.3, 3)
	if %TopDownCam.position.x > %TrainIcon.position.x:
		%TopDownCam.position = %TrainIcon.position
	
	%CloseClouds.scroll_offset.x += train_speed * delta
	%FarClouds.scroll_offset.x += train_speed * delta * 0.4

func _splashdown() -> void:
	get_tree().create_tween().tween_property(%Engine, "volume_db", -80, 1).set_trans(Tween.TRANS_EXPO)
	%Splash.emitting = true
	%SplashSound.play()
	get_tree().create_timer(1).timeout.connect(_drop)

func _drop() -> void:
	train_speed *= 2
	%TopDown.hide()
	%SideOn.show()
	%SideOnCam.make_current()
	get_tree().create_tween().tween_property(%Train, "position", Vector2(173, 300), 30).set_trans(Tween.TRANS_LINEAR)
	get_tree().create_tween().tween_property(%SideSplash1.process_material, "direction", Vector3(0.1, 0.2, 0), 3).finished.connect(_splashes_complete)
	get_tree().create_tween().tween_property(self, "train_speed", 0, 5)

func _splashes_complete() -> void:
	%SideSplash1.emitting = false
	%SideSplash2.emitting = false
	%SideSplash3.emitting = false

func _cover() -> void:
	get_tree().create_tween().tween_property(%Cover, "modulate", Color(1, 1, 1, 1), 1)

func _credits() -> void:
	%DfttSign.show()
	await get_tree().create_timer(12).timeout
	%DfttLetterWin.show()
	%DfttSign.hide()
	await get_tree().create_timer(50-12-22).timeout
	%DfttLetterCredits.show()
	%DfttLetterWin.hide()
	await get_tree().create_timer(4).timeout
	ready_to_return_to_menu = true
	%Spacepopup.show()
