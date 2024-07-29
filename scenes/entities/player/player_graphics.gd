extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
@onready var offset_y = get_parent().offset_y


"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func update_legs(direction: Vector2, on_floor: bool, crouch: bool):
	"""Update player's legs depending on his action and direction"""
	# If player's moving, try fliping the legs
	if direction.x:
		# Flip his legs if he's moving to the left
		$Legs.flip_h = direction.x < 0
		
	# Set the correct state based off of, if player is crouching or not
	var state = "Crouch" if crouch else "Idle"
	
	# If player is moving on the floor and isn't crouching, set his animation to run
	if on_floor and direction.x and not crouch:
		state = "Run"
	
	# If player isn't on the floor, set his state to jump
	if not on_floor:
		state = "Jump"
	
	# Update the animation
	$Legs.animation = state
	
func update_torso(direction: Vector2, crouch: bool, gun):
	"""Update player's torso based off of his action, direction and his current gun"""
	# Update player's torso depending on the gun
	$AnimationTree.gun = gun
	
	# Change position of player's torso, depending on if he's crouching
	$Torso.position.y = 0 if not crouch else offset_y
	
	# Get the correct direction of torso with all the weapons
	$AnimationTree["parameters/AK/blend_position"] = direction
	$AnimationTree["parameters/SG/blend_position"] = direction
	$AnimationTree["parameters/Rocket/blend_position"] = direction
