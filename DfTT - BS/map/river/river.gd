class_name River
extends Node2D

func set_direction(direction: int) -> void:
	if direction == 0:
		%Straight.show()
	if direction == -1:
		pass
