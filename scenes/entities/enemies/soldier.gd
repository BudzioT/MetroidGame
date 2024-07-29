extends CharacterBody2D


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
func _process(delta):
	"""Process soldier's changes over the frames"""
	# Check for edges, turn around if there is one
	_check_edges()
	# Also check if soldier should attack
	_check_attack()
	
	# Move the soldier
	_move()
	# Animate him
	_animate()

func _wall_area_entered(body):
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
		print("RIGHT")
	
	# Do the same for the left side
	if horizontal_direction < 0 and not $FloorRayCasts/Left.get_collider():
		horizontal_direction = 1
		print("LEFT")
		
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
		
		# Set the shoot animation depending on the direction
		$AnimationPlayer.current_animation = "Shoot_" + direction
		return
	
	# If soldier is moving, set his animation to run
	if horizontal_direction:
		$AnimationPlayer.current_animation = "Run"
	# Otherwise set it to idle
	else:
		$AnimationPlayer.current_animation = "Idle"
