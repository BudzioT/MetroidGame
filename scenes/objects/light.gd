@tool
extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Type of light
@export_enum('0', '1', '2', '3', '4', '5') var type = '0':
	# Setter
	set(value):
		# If value exists and there are types of lights, set the correct one
		if value != null and get_child_count() > 0:
			type = value
			# Hide all the lights
			for child in $Options.get_children():
				child.hide()
				
			# Show the correct light
			var light = $Options.get_child(int(type))
			light.show()
			
# Color of light
@export_color_no_alpha var color


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""

func _process(delta):
	"""Process the light's changes"""
	pass
	
