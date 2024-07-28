extends Sprite2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
@onready var offset_y = get_parent().crosshair_offset_y


"""---------------------------- USER-DEFINED FUNCTIONS ----------------------------"""
func update(direction, distance, crouch):
	"""Update the crosshair"""
	# Set the offset to down if player crouches
	var vertical_offset = offset_y if crouch else 0
	# Update position
	position = direction * distance + Vector2(0, vertical_offset)
	
