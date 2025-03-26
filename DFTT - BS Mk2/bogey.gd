class_name Bogey
extends Node2D

@onready var path: Path2D = %Path
@onready var follower: PathFollow2D = %Follower

var current_track_section: TrackSection
var next_track_section: TrackSection

var current_pole: Utils.Pole

func _process(delta: float) -> void:
	if follower.progress_ratio > 0.9:
		next_track_section = current_track_section.get_next_section(current_pole)
		current_pole = next_track_section.get_pole(current_track_section)
