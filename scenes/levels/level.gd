extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
const explosion_scene = preload("res://scenes/projectiles/explosion.tscn")


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the level"""
	# Go through each entity in the level
	for entity in $Entities/Drones.get_children():
		# Check if the entity is able to explode, connect the right function to the signal
		if entity.has_signal("explode"):
			entity.connect("explode", _explosion)
			

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _explosion(pos):
	"""Create an explosion"""
	# Create an explosion and add it to the scene
	var explosion = explosion_scene.instantiate()
	$Main/Projectiles.add_child(explosion)
	# Set its position
	explosion.position = pos
