class_name IntersectionSwitch
extends Node2D

var switch: Switch

func setup_switch(_switch: Switch) -> void:
	switch = _switch
	if not switch.left_turn:
		%Left.hide()
	if not switch.straight:
		%Straight.hide()
	if not switch.right_turn:
		%Right.hide()
	
	rotation = switch.direction.angle()

func _on_point_left_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("select"):
			switch.current_outbound = -1

func _on_point_right_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("select"):
			switch.current_outbound = 1

func _on_point_straight_box_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("select"):
			switch.current_outbound = 0
