@tool
extends Area2D

"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Enumerate with all available level names
@export_enum("stationInside", "underground", "outside") var level: String = "stationInside"
# Level scenes
var levels = { }


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the transition"""
	# Initialize the levels with proper scenes
	levels["stationInside"] = "res://scenes/levels/stationInside.tscn"
	levels["underground"] = "res://scenes/levels/underground.tscn"
	levels["outside"] = "res://scenes/levels/outside.tscn"

func _body_entered(_body):
	"""Handle player entering the gate"""
	# Change scene into one specified by the level, run the transition
	Transition.change_scene(levels[level])
