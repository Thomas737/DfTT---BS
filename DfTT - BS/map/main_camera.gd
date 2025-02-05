class_name MainCamera
extends Camera2D

var tutorial_camera: bool = true:
	set(new_state):
		if tutorial_camera and not new_state:
			_leave_tutorial()
		tutorial_camera = new_state
var ready_for_intersection: bool = false
var initial_position: Vector2 = position

const camera_TL = Vector2(-576, -324)
const camera_BR = Vector2(576, 324)

const limit_TL = Vector2(-500, -160)
const limit_BR = Vector2(900, 900)

const target_zoom = Vector2.ONE * 2

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().create_tween().tween_property(self, "zoom", %PierTarget.zoom, 1).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(2).timeout
	position = %PierTarget.position
	await get_tree().create_timer(10).timeout
	position = initial_position
	get_tree().create_timer(8).timeout.connect(_blink_bridge_failed)
	await get_tree().create_timer(8).timeout
	%BridgeExplosion.emitting = true
	%BridgeExplosionSound.play()
	%TempBridge.hide()
	ready_for_intersection = true
	get_tree().create_tween().tween_property(%DfttLetterTutorials, "modulate", Color(1,1,1,1), 2)
	position_smoothing_speed = 5

func _blink_bridge_failed() -> void:
	for blink in range(10):
		await get_tree().create_timer(0.5).timeout
		%BridgeFailed.hide()
		await get_tree().create_timer(0.5).timeout
		%BridgeFailed.show()

func _leave_tutorial() -> void:
	get_tree().create_tween().tween_property(self, "zoom", Vector2(2,2), 1).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(10).timeout
	get_tree().create_tween().tween_property(%DfttLetterTutorials, "modulate", Color(0,0,0,0), 2)

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
