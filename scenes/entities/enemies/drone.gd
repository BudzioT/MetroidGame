extends Entity


"""---------------------------- SIGNALS ----------------------------"""
signal explode(pos: Vector2)


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
var speed: int = Global.enemy_stats["Drone"]["speed"]

# Drone activated flag
var active: bool = false

# Reference to the player
@onready var player = get_tree().get_first_node_in_group("Player")


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the drone"""
	health = Global.enemy_stats["Drone"]["health"]

func _process(_delta):
	"""Apply changes to the drone over time"""
	# If drone is activated, move towards the player
	if active:
		_move()
		
func _player_area_entered(_body):
	"""Start following player when he enters the drone detection area"""
	active = true
	
func _player_area_exited(_body):
	"""Stop following player if he leaves the drone detection area"""
	active = false
	
func _collision_area_entered(body):
	"""Destroy the drone if it is too close to something"""
	# If drone collides with something other than itself, handle exploding
	if body != self:
		# Destroy the drone
		queue_free()
		# Send a signal to explode at the given position
		explode.emit(global_position)
		
		
"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _move():
	"""Move drone towards the player"""
	# Get direction to the player
	var direction = (player.position - position).normalized()
	
	# Calculate the velocity and move the drone
	velocity = direction * speed
	move_and_slide()
	
func _death():
	"""Handle drone's getting destroyed"""
	# Explode and destroy the drone
	explode.emit(global_position)
	queue_free()
	
func get_sprites():
	"""Get drone's sprites"""
	return [$AnimatedSprite2D]
