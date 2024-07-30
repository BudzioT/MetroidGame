extends Entity


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
var horizontal_direction: int = 1
var speed: int = Global.enemy_stats["Soldier"]["speed"]
# Speed modifier to prevent moving
var speed_multiplier: int = 1

# Reference to the player
@onready var player = get_tree().get_first_node_in_group("Player")

# Attack flag
var attack: bool = false


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Initialize the soldier"""
	health = Global.enemy_stats["Soldier"]["health"]

func _process(_delta):
	"""Process soldier's changes over the frames"""
	# Check for edges, turn around if there is one
	_check_edges()
	# Also check if soldier should attack
	_check_attack()
	
	# Move the soldier
	_move()
	# Animate him
	_animate()

func _wall_area_entered(_body):
	"""Change soldier's direction if he touches a wall"""
	horizontal_direction *= -1
	
	
"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _move():
	"""Handle soldier's movement"""
	# Update velocity and move the solider
	velocity.x = horizontal_direction * speed * speed_multiplier
	move_and_slide()

func _check_edges():
	"""Check if the soldier is near the edge, if that's the case, change his direction"""
	# If he moves to the right and doesn't see any floor on the right side
	if horizontal_direction > 0 and not $FloorRayCasts/Right.get_collider():
		# Change the direction
		horizontal_direction = -1
	
	# Do the same for the left side
	if horizontal_direction < 0 and not $FloorRayCasts/Left.get_collider():
		horizontal_direction = 1
		
func _check_attack():
	"""Check and set the attack state if player is close enough"""
	# If player is close enough, start attacking
	if position.distance_to(player.position) < 130:
		attack = true
		# Stop moving during attack
		speed_multiplier = 0
	# Otherwise stop attacking and start moving
	else:
		attack = false
		speed_multiplier = 1
		
func trigger_shoot():
	"""Make the soldier shoot"""
	# Calculate the direction
	var direction = (player.position - position).normalized()
	
	# Shoot
	shoot.emit(position + 20 * direction, direction, Global.weapons.AK)
	
func _death():
	"""Handle soldier's death"""
	
	
func get_sprites():
	"""Get soldier's sprites"""
	return [$Image]
		
func _animate():
	"""Animate the soldier"""
	# Flip the image if soldier if looking to the left
	$Image.flip_h = horizontal_direction == -1
	
	# If player is attacking, use the correct animation
	if attack:
		# Set direction soldier's direction to the player and direction difference to him 
		var direction = "Right"
		var difference = (player.position - position).normalized()
		
		# Flip the sprite in the player's direction
		$Image.flip_h = difference.x < 0
		# If player is close enough and is above the soldier, shoot up
		if difference.y < -0.5 and abs(difference.x) < 0.5:
			direction = "Up"
		# Do the same for down direction
		if difference.y > -0.5 and abs(difference.x) < 0.5:
			direction = "Down"
		
		# Set the shoot animation depending on the direction
		$AnimationPlayer.current_animation = "Shoot_" + direction
		return
	
	# If soldier is moving, set his animation to run
	if horizontal_direction:
		$AnimationPlayer.current_animation = "Run"
	# Otherwise set it to idle
	else:
		$AnimationPlayer.current_animation = "Idle"
