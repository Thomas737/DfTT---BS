class_name MainCamera
extends Camera2D

@export var tutorial_camera: bool = false

const camera_TL = Vector2(-576, -324)
const camera_BR = Vector2(576, 324)

const limit_TL = Vector2(-500, -160)
const limit_BR = Vector2(900, 900)

const target_zoom = Vector2.ONE * 2

func _unhandled_input(event: InputEvent) -> void:
	if tutorial_camera:
		return
	
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom

func _process(delta: float) -> void:
	if tutorial_camera:
		return
	
	var screen_centre: Vector2 = get_screen_center_position()
	var actual_TL: Vector2 = screen_centre + camera_TL / target_zoom
	var actual_BR: Vector2 = screen_centre + camera_BR / target_zoom
	
	if actual_TL.x < limit_TL.x:
		position.x += limit_TL.x - actual_TL.x
	if actual_TL.y < limit_TL.y:
		position.y += limit_TL.y - actual_TL.y
	
	if actual_BR.x > limit_BR.x:
		position.x -= actual_BR.x - limit_BR.x
	if actual_BR.y > limit_BR.y:
		position.y -= actual_BR.y - limit_BR.y
