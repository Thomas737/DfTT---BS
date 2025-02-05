class_name River
extends Node2D

func set_direction(direction: int, crossing: bool, flipped: bool, time_period: bool = true) -> void:
	for sprite: Sprite2D in get_children():
		sprite.hide()
	
	if crossing:
		if time_period:
			%Crossing.show()
		else:
			%CrossingSteam.show()
		return
	
	if direction == 0:
		if time_period:
			%Straight.show()
		else:
			%StraightSteam.show()
	if direction == -1:
		if time_period:
			%Left.show()
		else:
			%LeftSteam.show()
	if direction == 1:
		if time_period:
			%Right.show()
		else:
			%RightSteam.show()
	if flipped:
		%Straight.flip_h = true
		%Left.flip_v = true
		%Right.flip_h = true
		%StraightSteam.flip_h = true
		%LeftSteam.flip_v = true
		%RightSteam.flip_h = true
