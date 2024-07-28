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

# Jump variables
@export_group("Jump")
@export var jump_power: int = 280
@export var gravity: int = 500


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta):
	"""Process player's changes in every frame"""
	# If player can move, handle user's input, move the player and apply gravity to him
	if moveable:
		_handle_input()
		_move(delta)
		_apply_gravity(delta)

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _handle_input():
	"""Get and handle player's input"""
	# Handle horizontal movement changes
	direction.x = Input.get_axis("Left", "Right")
	
func _move(delta):
	"""Move the player"""
	# If there is any movement to the right, move that way up to a certain speed
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	# Otherwise, gradually lower the speed up to 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	# Move him
	move_and_slide()
	
func _apply_gravity(delta):
	"""Apply gravity to the player"""
	pass
