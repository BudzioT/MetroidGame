extends CanvasLayer


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	# Make the transition invisible if not changing level
	$ColorRect.modulate = Color(0, 0)
	
	
"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func change_scene(target_scene):
	"""Change the scene and turn start the transition"""
	# Get the player and stop his movement
	get_tree().get_first_node_in_group("Player").stop_movement()
	
	# Tween to manage the color alpha
	var tween  = create_tween()
	
	# Show the transition in duration of 0.7 seconds, then hide with the same duration
	tween.tween_property($ColorRect, "modulate", Color(0, 1), 0.7)
	# Load the scene
	tween.tween_callback(Callable(self, "_load_scene").bind(target_scene))
	# Hide the transition
	tween.tween_property($ColorRect, "modulate", Color(0, 0), 0.5)
	
func _load_scene(path):
	"""Load the proper scene from the given path"""
	get_tree().change_scene_to_file(path)
