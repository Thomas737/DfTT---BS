class_name PauseMenu
extends CanvasLayer

func _on_continue() -> void:
	print("here_continue")
	hide()
	get_tree().paused = false

func _on_exit() -> void:
	hide()
	get_tree().paused = false

func _on_controls() -> void:
	%PauseScreen.hide()
	%ControlsScreen.show()

func _on_exit_controls() -> void:
	%PauseScreen.show()
	%ControlsScreen.hide()
