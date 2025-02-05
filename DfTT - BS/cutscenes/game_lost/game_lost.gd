class_name GameLost
extends CanvasLayer

const main_menu = preload("res://menus/main_menu.tscn")

var cutscene_over: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("space") and cutscene_over:
			get_tree().change_scene_to_packed(main_menu)

func _ready() -> void:
	%Spacepopup.hide()
	get_tree().create_timer(2).timeout.connect(%Explosion.play)
	await get_tree().create_timer(4).timeout
	get_tree().create_tween().tween_property(%DfttLetterFail, "modulate", Color(1, 1, 1, 1), 2)
	await get_tree().create_timer(8).timeout
	%Spacepopup.show()
	cutscene_over = true
