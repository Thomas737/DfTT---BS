class_name MechanicalSwitch
extends Node2D

signal new_direction_set(direction: int)

var mouse_on_handle: bool = false
var handle_selected: bool = false

var forward: bool = true
var limits: Array[float]

func _process(delta: float) -> void:
	if handle_selected:
		%Handle.rotation = clampf(get_local_mouse_position().y/60, limits[0], limits[1])

func setup_switch(angle_limits: Array[float], initial_direction: int) -> void:
	limits = angle_limits
	if initial_direction == -1:
		%Handle.rotation = -PI/2
	elif initial_direction == 0:
		%Handle.rotation = 0
	else:
		%Handle.rotation = PI/2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("select") and mouse_on_handle:
			handle_selected = true
		if event.is_action_released("select"):
			handle_selected = false
			on_handle_released()

func on_handle_released() -> void:
	var tween: Tween = get_tree().create_tween()
	if %Handle.rotation > PI/4:
		tween.tween_property(%Handle, "rotation", PI/2, 0.5).set_trans(Tween.TRANS_CUBIC)
		new_direction_set.emit(1)
	elif %Handle.rotation < -PI/4:
		tween.tween_property(%Handle, "rotation", -PI/2, 0.5).set_trans(Tween.TRANS_CUBIC)
		new_direction_set.emit(-1)
	elif forward:
		tween.tween_property(%Handle, "rotation", 0, 0.5).set_trans(Tween.TRANS_CUBIC)
		new_direction_set.emit(0)
	elif %Handle.rotation > 0:
		tween.tween_property(%Handle, "rotation", PI/2, 0.5).set_trans(Tween.TRANS_CUBIC)
		new_direction_set.emit(1)
	else:
		tween.tween_property(%Handle, "rotation", -PI/2, 0.5).set_trans(Tween.TRANS_CUBIC)
		new_direction_set.emit(-1)
	tween.tween_callback(_on_handle_tween_complete)

func _on_handle_tween_complete() -> void:
	%Snap.play()

func _mouse_entered_handle() -> void:
	mouse_on_handle = true

func _mouse_exited_handle() -> void:
	mouse_on_handle = false
