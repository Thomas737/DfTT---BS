class_name Train
extends Node2D

signal new_switch(train: Train, switch: Switch)

@export var train_resource: TrainResource

var current_switch: Switch = null

func _process(delta: float) -> void:
	if %MapRepresentation.progress_ratio >= 1 or not %CurrentTrack.curve:
		get_next_track()
	
	%MapRepresentation.progress += 10 * delta

func get_next_track() -> void:
	var new_curve: Curve2D = current_switch.get_outbound_path()
	%CurrentTrack.position = current_switch.global_position
	%CurrentTrack.rotation = current_switch.global_rotation
	%CurrentTrack.curve = new_curve
	%MapRepresentation.progress = 0
	current_switch = current_switch.get_outbound_switch()
	new_switch.emit(self, current_switch)
