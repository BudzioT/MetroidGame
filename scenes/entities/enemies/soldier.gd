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
	# Update velocity and move the solider
	velocity.x = horizontal_direction * speed * speed_multiplier
	move_and_slide()
