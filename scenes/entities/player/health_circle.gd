extends Sprite2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Reference to the player
@onready var player = get_tree().get_first_node_in_group("Player")

"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the health bar"""
	# Make it not visible at the start
	material.set_shader_parameter("alpha", 0.0)
	
"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func update(value):
	"""Update the player's health circle"""
	# A tween to manage health circle
	var tween = create_tween()
	
	# Make the health circle visible
	tween.tween_property(self, "material:shader_parameter/alpha", 1.0, 0.3)
	# Update the health's progress
	tween.tween_property(self, "material:shader_parameter/progress", value / 100.0, 0.2)
	# Hide it again
	tween.tween_property(self, "material:shader_parameter/alpha", 0.0, 0.4)
