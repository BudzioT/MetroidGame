extends Node2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the level"""
	# Go through each entity in the level
	for entity in $Entities.get_children():
		# Check if the entity is able to explode, connect the right function to the signal
		if entity.has_signal("explode"):
			entity.connect("explode", _explosion)
			

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _explosion():
	"""Create an explosion"""
	print("EXPLOSION")
