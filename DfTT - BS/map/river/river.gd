class_name River
extends Node2D

func set_direction(direction: int, crossing: bool, flipped: bool) -> void:
	if crossing:
		%Crossing.show()
		return
	
	if direction == 0:
		%Straight.show()
	if direction == -1:
		%Left.show()
	if direction == 1:
		%Right.show()
	if flipped:
		%Straight.flip_h = true
		%Left.flip_v = true
		%Right.flip_h = true
