class_name TamperCutscene
extends Node2D

func _ready() -> void:
	%WorkshopSounds.play()
	%Bogey.play()
	%Bogey.animation_finished.connect(_on_bogey_opened)

func _on_bogey_opened() -> void:
	%Bogey.animation_finished.disconnect(_on_bogey_opened)
	var timer: SceneTreeTimer = get_tree().create_timer(5)
	timer.timeout.connect(_on_tampering_complete)
	%Sparks.emitting = true
	%WeldingSound.play()

func _on_tampering_complete() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(2)
	timer.timeout.connect(_on_explosion)
	%Sparks.emitting = false

func _on_explosion() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(2)
	timer.timeout.connect(_on_fire_spread)
	%SmallExplosion.play()
	%Fire.emitting = true
	%Fire2.emitting = true
	%Bogey.animation = "smoke_loop"

func _on_fire_spread() -> void:
	%Smoke.emitting = true
