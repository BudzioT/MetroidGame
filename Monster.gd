extends Entity


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Reference to the player
@onready var player = get_tree().get_first_node_in_group("Player")
# Camera reference
@onready var camera = player.get_camera()
@onready var camera_size = camera.get_viewport_rect().size.x / camera.zoom.x

# Horizontal position limits, where x is the minimum and y is the maximum
@export var limits: Vector2i

# Monster's vertical limit range
var vertical_range: Vector2 = Vector2(-50, 50)
var vertical_offset: float

# Random number generator
var rng = RandomNumberGenerator.new()


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(_delta):
	"""Process monster changes over frames"""
	# Horizontal position off the monster, set to the right side of game's camera
	var x = player.position.x + camera_size / 2 - 30
	# Adjust the horizontal position based off set limits
	x = max(limits.x, min(limits.y, x))
	
	# Set monster's position to the calculated position, and to the player's vertical one
	position = Vector2(x, player.position.y + vertical_offset)

func _move_timeout():
	"""Handle vertical movement when cooldown passes"""
	# Create a tween to manage the position
	var tween = create_tween()
	# Randomize the vertical offset, based on the specified range
	tween.tween_property(self, "vertical_offset", 
		rng.randf_range(vertical_range.x, vertical_range.y), 0.8)
	
	# After done moving, activate the cooldown
	tween.tween_callback($Timers/Move.start)

func _attack_timeout():
	"""Handle attacks, when cooldown passes"""
	# Set the animation to attack
	$AnimationPlayer.current_animation = "Attack"
	
	# Choose a random attack cooldown
	$Timers/Attack.wait_time = rng.randf_range(0.5, 1.5)
	# Start it
	$Timers/Attack.start()
	

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _attack():
	"""Make the monster attack"""
	# Choose a random bullet layout index, and get the layout at it
	var layout_index = rng.randi_range(0, $Bullets.get_child_count() - 1)
	var layout = $Bullets.get_child(layout_index)
	
	# Shoot from every position that is in the chosen layout
	for marker in layout.get_children():
		shoot.emit(marker.global_position, Vector2.LEFT, Global.weapons.AK)
	
func _set_idle():
	"""Set the state to idle"""
	$AnimationPlayer.current_animation = "Idle"
	
func get_sprites():
	"""Get monster's sprites"""
	return [$AttackImage]
