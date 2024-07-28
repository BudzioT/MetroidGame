extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Movement variables
@export_group("Movement")
@export var speed: int = 200
var direction: Vector2 = Vector2.ZERO

@export var acceleration: int = 400
@export var friction: int = 550

# Movement ability flag
var moveable: bool = true
# Crouch flag
var crouch: bool = false

# Dash variables
@export_group("Dash")
# Its cooldown
@export_range(0.1, 2) var dash_cooldown: float = 0.5
@export var dash_distance: int = 600
@export var dash_friction: int = 600

# Dash flag
var dash: bool = false

# Jump variables
@export_group("Jump")
@export var jump_power: int = 310
@export var gravity: int = 600
var gravity_multiplier: int = 1
@export var terminal_velocity: int = 450

# Jump flag
var jump: bool = false
# Fast falling flag
var fast_fall: bool = false

# Shooting related variables
@export_group("Shoot")
# Distance of the crosshair from player
@export var crosshair_distance: int = 20
# Vertical offset of the crosshair
@export var offset_y: int = 6

# Current player's gun
var gun = Global.weapons.AK

# Direction of aiming
var aim_direction: Vector2 = Vector2.RIGHT

# Gamepad is used flag
var gamepad: bool = true


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta):
	"""Process player's changes in every frame"""
	# Apply gravity to the player
	_apply_gravity(delta)
	
	# If player can move, handle user's input, move the player
	if moveable:
		_handle_input()
		_move(delta)
		
		# Animate him
		_animate()
		
func _ready():
	"""Prepare the player"""
	$Timers/DashCooldown.wait_time = dash_cooldown
	
func _input(event):
	"""Watch for input and handle it"""
	# Turn off the gamepad flag if player uses mouse
	if event is InputEventMouseMotion:
		gamepad = false
	# Turn on the gamepad if player uses it
	if Input.get_vector("AimLeft", "AimRight", "AimUp", "AimDown"):
		gamepad = true
	

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _handle_input():
	"""Get and handle player's input"""
	# Handle horizontal movement changes
	direction.x = Input.get_axis("Left", "Right")
	
	# Handle jumps when it's pressed
	if Input.is_action_just_pressed("Jump"):
		_jump()
		
	# Handle stopping jump, by setting the fast fall flag to true
	if Input.is_action_just_released("Jump") and not is_on_floor() and velocity.y < 0:
		fast_fall = true
		
	# Handle dashing if player's moving and cooldown isn't active
	if Input.is_action_just_pressed("Dash") and velocity.x and not $Timers/DashCooldown.time_left:
		dash = true
		$Timers/DashCooldown.start()
		
	# Crouch if player pressed the right button and is on the floor
	if Input.is_action_pressed("Crouch") and is_on_floor():
		crouch = true
	# Otherwise reset the crouch flag
	else:
		crouch = false
		
	# Get the aim axis from gamepad and mouse
	var aim_gamepad = Input.get_vector("AimLeft", "AimRight", "AimUp", "AimDown")
	var aim_mouse = get_local_mouse_position().normalized()
	
	# Choose the right axis depending on if the player uses a controller
	var aim = aim_mouse if not gamepad else aim_gamepad
	
	# If aim is far enough, change it
	if aim.length() > 0.5:
		# Get the direction from currently used aim, round it to get the direction
		aim_direction = Vector2(round(aim.x), round(aim.y))
		
	# Handle player switching weapons
	if Input.is_action_just_pressed("Switch"):
		# Get the next gun index, loop it if needed
		var gun_index = (gun + 1) % len(Global.weapons)
		# Set the current gun
		gun = Global.weapons[Global.weapons.keys()[gun_index]]
	
func _move(delta):
	"""Move the player"""
	# If there is any movement to the right, move that way up to a certain speed
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	# Otherwise, gradually lower the speed up to 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	# If player is crouching, don't allow him to move horizontally
	if crouch:
		velocity.x = 0
		
	# If player wants to jump or jump buffer is activated while on floor
	if jump or $Timers/JumpBuffer.time_left and is_on_floor():
		# Decrease his velocity
		velocity.y = -jump_power
		# Stop increasing velocity after player jumped, by setting the flag again to false
		jump = false
		# Set fast fall to false at the beginning
		fast_fall = false
		
	# Store if the player is on the floor
	var on_floor = is_on_floor()
	
	# Move him
	move_and_slide()
	
	# If player was on the floor before moving and isn't now, plus he's falling
	if on_floor and not is_on_floor() and velocity.y >= 0:
		# Start the coyote
		$Timers/Coyote.start()
		
	# If player wants to dash, do it
	if dash:
		# Disable dash
		dash = false
		
		# Stop gravity from affecting the player
		gravity_multiplier = 0
		
		# Create a tween to manage dash
		var tween = create_tween()
		# Set the player's velocity a really high one over 0.3 seconds
		tween.tween_property(self, "velocity:x", 
			velocity.x + direction.x * dash_distance, 0.3)
		
		# Call dash finish function, when the dash ends
		tween.connect("finished", _finish_dash)
		
func _jump():
	"""Make the player jump"""
	# Set the jump flag if player is on the floor or he does a coyote jump
	if is_on_floor() or $Timers/Coyote.time_left:
		jump = true
			
	# If player is falling and isn't on the floor already, start the jump buffer timer
	if velocity.y > 0 and not is_on_floor():
		$Timers/JumpBuffer.start()
	
func _apply_gravity(delta):
	"""Apply gravity to the player"""
	# Change the velocity based off gravity
	velocity.y += gravity * delta * gravity_multiplier
	
	# If player stopped the jump mid-through, make his jump smaller
	if fast_fall and velocity.y < 0:
		velocity.y = velocity.y / 2
	
	# Make it not exceed the terminal velocity
	velocity.y = min(velocity.y, terminal_velocity)
	
func _finish_dash():
	"""Finish dash action"""
	# Stop the dash
	velocity.x = move_toward(velocity.x, 0, dash_friction)
	# Make gravity affect the player again
	gravity_multiplier = 1
	
func _animate():
	"""Animate the player"""
	# Update the crosshair
	$Crosshair.update(aim_direction, crosshair_distance, crouch)
	
	# Update player's legs animation
	$PlayerGraphics.update_legs(direction, is_on_floor(), crouch)
	# Update his torso's position and frame
	$PlayerGraphics.update_torso(aim_direction, crouch, gun)
