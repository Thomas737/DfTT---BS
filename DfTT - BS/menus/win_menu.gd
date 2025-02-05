class_name WinMenu
extends Node2D

func _ready() -> void:
	%GameWon.tree_exiting.connect(%MainMenu.show)
	_play_win_theme()

func _play_win_theme() -> void:
	%WinMusic.play()
	get_tree().create_timer(150).timeout.connect(_play_win_theme)
