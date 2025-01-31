class_name IntersectionSwitch
extends Node2D

var switch: Switch
@export var mechanical_switch: MechanicalSwitch

func setup_switch(_switch: Switch) -> void:
	switch = _switch
	var direction_limits: Array[float] = [-PI/2, PI/2]
	
	if not switch.left_turn:
		direction_limits[0] = 0
		%Left.hide()
	if not switch.straight:
		mechanical_switch.forward = false
		%Straight.hide()
	if not switch.right_turn:
		direction_limits[1] = 0
		%Right.hide()
	
	mechanical_switch.setup_switch(direction_limits, switch.get_outbound_direction())
	mechanical_switch.new_direction_set.connect(_set_switch_direction)
	
	for train: Train in switch.inbound_trains:
		await ready
		var timer: SceneTreeTimer = get_tree().create_timer(1.5-train.get_map_representation().progress_ratio*1.7)
		timer.timeout.connect(train.setup_close_view.bind(%StraightPath.curve, false, switch.rotation, train.get_map_representation().progress_ratio))
	for train: Train in switch.outbound_trains:
		var outbound_direction: int = switch.get_outbound_direction()
		if outbound_direction == 0:
			train.setup_close_view(%StraightPath.curve, true, switch.rotation)
		if outbound_direction == 1:
			train.setup_close_view(%RightPath.curve, true, switch.rotation)
		if outbound_direction == -1:
			train.setup_close_view(%LeftPath.curve, true, switch.rotation)
	
	switch.new_train.connect(_new_train)
	switch.train_outbound.connect(_new_outbound)
	rotation = switch.direction.angle()

func _set_switch_direction(direction: int) -> void:
	switch.current_outbound = direction

func _await_new_train() -> void:
	pass

func _new_train(train: Train) -> void:
	await get_tree().create_timer(2.5).timeout
	train.setup_close_view(%StraightPath.curve, false, switch.rotation)

func _new_outbound(train: Train, outbound_direction: int) -> void:
	var new_path: Curve2D
	if outbound_direction == -1:
		new_path = %LeftPath.curve
	elif outbound_direction == 0:
		new_path = %StraightPath.curve
	else:
		new_path = %RightPath.curve
	train.setup_new_close_path(new_path)
