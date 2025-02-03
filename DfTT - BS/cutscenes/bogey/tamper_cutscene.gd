class_name TamperCutscene
extends Node2D

func _ready() -> void:
	%WorkshopSounds.play()
	%WorkshopSounds.finished.connect(_on_workshop_sounds_complete)
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
	%SmallExplosion.play()
	%FireSound.play()
	%FireSound.finished.connect(_on_scene_over)
	%Fire.emitting = true
	%Bogey.animation = "smoke_loop"

func _on_workshop_sounds_complete() -> void:
	get_tree().create_tween().tween_property(%Fade, "modulate", Color.WHITE, 3).set_trans(Tween.TRANS_CUBIC)

func _on_scene_over() -> void:
	get_tree().change_scene_to_file("res://cutscenes/parallax/parallax_cutscene.tscn")
