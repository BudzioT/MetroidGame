extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Scenes
const explosion_scene = preload("res://scenes/projectiles/explosion.tscn")
const bullet_scene = preload("res://scenes/projectiles/bullet.tscn")


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the level"""
	# Go through each entity in the level
	for entity in $Entities/Drones.get_children():
		# Connect the explosion function to the right signal
		entity.connect("explode", _explosion)
		
	# Go through each entity type
	for entity_type in $Entities.get_children():
		# Go through each of the entities
		for entity in entity_type.get_children():
			# If entity is able to shoot, connect a function to create projectiles
			if entity.has_signal("shoot"):
				entity.connect("shoot", _create_projectile)
				
	# Create a projectile when player shoots
	$Entities/Player.connect("shoot", _create_projectile)
			

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _explosion(pos):
	"""Create an explosion"""
	# Create an explosion and add it to the scene
	var explosion = explosion_scene.instantiate()
	$Main/Projectiles.add_child(explosion)
	# Set its position
	explosion.position = pos
	
func _create_projectile(pos, dir, bullet_type):
	"""Create a projectile"""
	var bullet = bullet_scene.instantiate()
	$Main/Projectiles.add_child(bullet)
	
	# Initialize the bullet
	bullet.initialize(pos, dir, bullet_type)
	
	# If bullet is from a rocket, make it explosive
	if bullet_type == Global.weapons.ROCKET:
		bullet.connect("explode", _explosion)
