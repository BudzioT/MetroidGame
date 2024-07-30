extends Area2D


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
