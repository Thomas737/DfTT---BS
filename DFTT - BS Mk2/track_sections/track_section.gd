class_name TrackSection
extends Node2D

@export var node_sections: Array[TrackSection]
@export var anti_sections: Array[TrackSection]

var nodebound: int = 0
var antibound: int = 0

func _ready() -> void:
	pass

## This function determines which side of [self] the [previous_track] is on.
## It then returns the pole of the opposite side for later requests
func get_pole(previous_section: TrackSection) -> Utils.Pole:
	if previous_section in anti_sections:
		return Utils.Pole.NODE
	return Utils.Pole.ANTI

## Gets next track section for a given pole. Queries the relevant direction
## and returns the result based on the signal state of the track
func get_next_section(pole: Utils.Pole) -> TrackSection:
	if pole == Utils.Pole.NODE: return node_sections[nodebound]
	else: return anti_sections[antibound]
