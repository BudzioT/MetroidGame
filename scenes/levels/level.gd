extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Scenes
const explosion_scene = preload("res://scenes/projectiles/explosion.tscn")
const bullet_scene = preload("res://scenes/projectiles/bullet.tscn")

# Get camera limits and a reference to the game's camera
@export var camera_limit: Vector4i
@onready var camera: Camera2D = get_tree().get_first_node_in_group("Player").get_camera()


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the level"""
	# Set the camera limits
	camera.limit_top = camera_limit.y
	camera.limit_bottom = camera_limit.w
	camera.limit_left = camera_limit.x
	camera.limit_right = camera_limit.z
	
	# Go through each entity in the level
	for entity in $Entities/Drones.get_children():
		# Connect the explosion function to the right signal
		entity.connect("explode", _explosion)
			
	# Flag indicating a need to load data
	var load_data = false
	# Get the scene name and check if the enemy data of this scene exists
	var scene_name = get_tree().current_scene.name
	if scene_name in Global.enemy_data:
		load_data = true
	
	# Index of the currently searched entity
	var entity_index = 0
	
	# Go through each entity type
	for entity_type in $Entities.get_children():
		# If it isn't a player and drones
		if entity_type.name != "Player" and entity_type.name != "Drones":
			# Go through each of the entities
			for entity in entity_type.get_children():
				# If entity is able to shoot, connect a function to create projectiles
				if entity.has_signal("shoot"):
					entity.connect("shoot", _create_projectile)
				
				
				if load_data:
					# Initialize the entity
					entity.initialize(Global.enemy_data[scene_name][entity_index])
					# Increase the entity index
					entity_index += 1
				
	# Create a projectile when player shoots
	$Entities/Player.connect("shoot", _create_projectile)
	
func _exit_tree():
	"""Handle exiting the level"""
	# Make an array reperesenting current enemy's data
	var current_enemy_data: Array = []
	# Go through each of the entity type
	for entity_type in $Entities.get_children():
		
		# If it isn't a player and drones
		if entity_type.name != "Player" and entity_type.name != "Drones":
			# Go through each entity of the specified type
			for entity in entity_type.get_children():
				# Store its position, velocity and health
				current_enemy_data.append([entity.position, entity.velocity, entity.health])
	
	# Store enemy's data globally
	Global.enemy_data[get_tree().current_scene.name] = current_enemy_data
	
	print(Global.enemy_data[get_tree().current_scene.name])
			

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
