class_name MainMenu
extends Node2D

@export var main_theme_on: bool = true

func _ready() -> void:
	if main_theme_on:
		_play_main_theme()

func _play_main_theme() -> void:
	%Soundtrack.play()
	get_tree().create_timer(110).timeout.connect(_play_main_theme)

func _on_play_pressed() -> void:
	Global.game_start()

func _on_play_with_cutscenes_pressed() -> void:
	get_tree().change_scene_to_file("res://cutscenes/bogey/tamper_cutscene.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
