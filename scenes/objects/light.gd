@tool
extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Type of light
@export_enum('0', '1', '2', '3', '4', '5') var type: String = '0':
	# Setter
	set(value):
		# If value exists and there are types of lights, set the correct one
		if value and get_child_count() > 0:
			type = value
			# Hide all the lights
			for child in $Options.get_children():
				child.hide()
				
			# Show the correct light
			var light = $Options.get_child(int(type))
			light.show()
			
# Its energy
@export_range(0, 10) var energy: float = 1.0:
	# Setter of the light's strength
	set(value):
		# If there is a value, and light has a type, set energy of it
		if value and get_child_count() and type:
			energy = value
			# Set the energy of the current light
			$Options.get_child(int(type)).get_child(1).energy = energy
			
# Color of light
@export_color_no_alpha var color = Color(1.0, 1.0, 1.0, 1.0):
	# Setter
	set(value):
		# If value exists, there is a type of light set, change the light's color
		if value and get_child_count() > 0 and type:
			color = value
			# Set the Point Light's color
			$Options.get_child(int(type)).get_child(1).color = color
			
# Flicker power
@export_range(0, 200) var flicker: float = 100

# Its noise
var noise = FastNoiseLite.new()
# Current noise value
var noise_value: float = 0.0
			
# Radius of the general light
@export_range(0, 20) var radius: float = 1.0:
	# Set the radius
	set(value):
		# Check if there is a value, set the radius
		if value:
			radius = value
			# Set radius of the general light
			$GeneralLight.texture_scale = radius
			
# Currently active light
var current_light: PointLight2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""

func _ready():
	"""Initialize the light"""
	# Go through each of light types, check which one is visible and set it as the current one
	for light in $Options.get_children():
		if light.visible:
			# Get the first child of the light, which is the Point Light
			current_light = light.get_child(1)

func _process(delta):
	"""Process the light's changes"""
	# Update the noise value
	noise_value += flicker * delta
	
	# If there is currently active light, set its energy to the noise with given value
	if current_light:
		current_light.energy = (noise.get_noise_1d(noise_value) + 1 / 4.0) + 0.5
