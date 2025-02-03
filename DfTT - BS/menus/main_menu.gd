class_name MainMenu
extends CanvasLayer

func _ready() -> void:
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://cutscenes/bogey/tamper_cutscene.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
