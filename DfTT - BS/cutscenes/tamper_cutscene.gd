class_name TamperCutscene
extends Node2D

func _ready() -> void:
	%Bogey.play()
	%Bogey.animation_finished.connect(_on_bogey_opened)

func _on_bogey_opened() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(5)
	timer.timeout.connect(_on_tampering_complete)

func _on_tampering_complete() -> void:
	%Bogey.animation = "smoke_developing"
	%Bogey.play()
	%Bogey.animation_finished.connect(_on_smoke_developed)

func _on_smoke_developed() -> void:
	%Bogey.animation = "smoke_loop"
	%Bogey.play()
