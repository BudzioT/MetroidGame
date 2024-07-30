extends Entity


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Reference to the player
@onready var player = get_tree().get_first_node_in_group("Player")
# Camera reference
@onready var camera = player.get_camera()
@onready var camera_size = camera.get_viewport_rect().size.x / camera.zoom.x

"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta):
	"""Process monster changes over frames"""
	# Place monster at the right side of game's camera
	position.x = player.position.x + camera_size / 2 - 30
	# Set monster's vertical position to the player's one
	position.y = player.position.y

func _move_timeout():
	pass

func _attack_timeout():
	pass
