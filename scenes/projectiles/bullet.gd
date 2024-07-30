extends Area2D


"""---------------------------- SIGNALS ----------------------------"""
signal explode(pos: Vector2)


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
var direction: Vector2
# Weapon stats
var speed: int
var damage: int

# Explosive bullet flag
var explosive: bool = false


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta):
	"""Process bullet changes"""
	position += direction * speed * delta
	
func _body_entered(body):
	"""Detonate when a body enters the bullet"""
	# Explode
	explode.emit(position)
	
	# If it hit an object that is damagable, make it take damage
	if "hit" in body:
		body.hit(damage, body.get_sprites())
	
	# Destroy the bullet
	queue_free()
	
func _life_timer_timeout():
	"""Destroy the bullet when its life time ends"""
	queue_free()


"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func initialize(pos, dir, type):
	"""Initialize the bullet"""
	# Set the position and direction, normalize it to prevent speed increases
	position = pos
	direction = dir.normalized()
	
	# If the weapon is an AK or a Rocket, save the correct data
	if type in [Global.weapons.AK, Global.weapons.ROCKET]:
		# Grab the correct texture
		$Image.texture = Global.weapon_stats[type]["texture"]
		
		# Save speed and damage
		speed = Global.weapon_stats[type]["speed"]
		damage = Global.weapon_stats[type]["damage"]
		
		# If bullet comes from the rocket, make it explosive
		if type == Global.weapons.ROCKET:
			explosive = true
			
	# Otherwise if projectile is from a SG, don't show it
	else:
		# Disable the collision shape, hide the image
		$CollisionPolygon2D.disabled = true
		$Image.hide()
		# Hide the light
		$PointLight2D.hide()
		
		# Get all the enemies
		var enemies = get_tree().get_nodes_in_group("Enemies")
		# Go through each of the enemy
		for enemy in enemies:
			# Calculate the angle of a bullet and the enemy
			var bullet_angle = rad_to_deg(direction.angle())
			var enemy_angle = rad_to_deg((enemy.position - pos).angle())
			
			# If enemy is in the SG range and angle is right, hit the enemy
			if pos.distance_to(enemy.position) < Global.weapon_stats[Global.weapons.SG]["range"]\
				and abs(bullet_angle - enemy_angle):
					enemy.hit(Global.weapon_stats[Global.weapons.SG]["damage"], 
						enemy.get_sprites())
