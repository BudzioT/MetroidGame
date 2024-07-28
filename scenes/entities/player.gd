extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Movement variables
@export_group("Movement")
@export var speed: int = 200
var direction: Vector2 = Vector2.ZERO

var acceleration: int = 400
var friction: int = 550

# Movement ability flag
var moveable: bool = true

# Dash flag
var dash: bool = false
# Its cooldown
@export_range(0.1, 2) var dash_cooldown: float = 0.5

# Jump variables
@export_group("Jump")
@export var jump_power: int = 310
@export var gravity: int = 600
@export var terminal_velocity: int = 450

# Jump flag
var jump: bool = false
# Fast falling flag
var fast_fall: bool = false


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta):
	"""Process player's changes in every frame"""
	# Apply gravity to the player
	_apply_gravity(delta)
	
	# If player can move, handle user's input, move the player
	if moveable:
		_handle_input()
		_move(delta)

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _handle_input():
	"""Get and handle player's input"""
	# Handle horizontal movement changes
	direction.x = Input.get_axis("Left", "Right")
	
	# Handle jumps when it's pressed
	if Input.is_action_just_pressed("Jump"):
		# Set the jump flag if player is on the floor or he does a coyote jump
		if is_on_floor() or $Timers/Coyote.time_left:
			jump = true
			
		# If player is falling and isn't on the floor already, start the jump buffer timer
		if velocity.y > 0 and not is_on_floor():
			$Timers/JumpBuffer.start()
		
	# Handle stopping jump, by setting the fast fall flag to true
	if Input.is_action_just_released("Jump") and not is_on_floor() and velocity.y < 0:
		fast_fall = true
		
	# Handle dashing if player's moving
	if Input.is_action_just_pressed("Dash") and velocity.x:
		pass
	
func _move(delta):
	"""Move the player"""
	# If there is any movement to the right, move that way up to a certain speed
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	# Otherwise, gradually lower the speed up to 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	# If player wants to jump or jump buffer is activated while on floor
	if jump or $Timers/JumpBuffer.time_left and is_on_floor():
		# Decrease his velocity
		velocity.y = -jump_power
		# Stop increasing velocity after player jumped, by setting the flag again to false
		jump = false
		# Set fast fall to false at the beginning
		fast_fall = false
		
	# Store if the player is on the floor
	var floor = is_on_floor()
	
	# Move him
	move_and_slide()
	
	# If player was on the floor before moving and isn't now, plus he's falling
	if floor and not is_on_floor() and velocity.y >= 0:
		# Start the coyote
		$Timers/Coyote.start()
	
func _apply_gravity(delta):
	"""Apply gravity to the player"""
	# Change the velocity based off gravity
	velocity.y += gravity * delta;
	
	# If player stopped the jump mid-through, make his jump smaller
	if fast_fall and velocity.y < 0:
		velocity.y = velocity.y / 2
	
	# Make it not exceed the terminal velocity
	velocity.y = min(velocity.y, terminal_velocity)
