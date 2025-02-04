class_name MainMenu
extends CanvasLayer

func _ready() -> void:
	_play_main_theme()

func _play_main_theme() -> void:
	%Soundtrack.play()
	get_tree().create_timer(110).timeout.connect(_play_main_theme)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://cutscenes/bogey/tamper_cutscene.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
