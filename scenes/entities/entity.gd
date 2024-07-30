class_name Entity
extends CharacterBody2D


"""---------------------------- SIGNALS ----------------------------"""
signal shoot(position, direction, weapon)


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
var health: int = 100:
	# Setter of the health
	set(value):
		health = value
		
		# If this is player's health
		if is_in_group("Player"):
			# Update the health circle
			get_tree().get_first_node_in_group("HealthCircle").update(health)
		
		# If entity has no more health, make it die
		if health <= 0:
			_death()


"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func hit(damage, nodes):
	"""Handle getting hit"""
	# If entity isn't invincible, make it take some damage
	if not $Timers/Invincibility.time_left:
		# Decrease the health
		health -= damage
		
		# Turn on the flash effect
		_flash(nodes)
		
		# Make entity unhitable again
		$Timers/Invincibility.start()
	
func _death():
	"""Handle dying"""
	pass
	
func _flash(nodes):
	"""Make the sprite flash"""
	# Create a tween to manage flashing
	var tween = create_tween()
	# Flash the sprite, during some duration
	tween.tween_method(set_flash.bind(nodes), 0.0, 1.0, 0.2).set_trans(tween.TRANS_QUAD)
	# Make colors normal again
	tween.tween_method(set_flash.bind(nodes), 1.0, 0.0, 0.4).set_trans(tween.TRANS_QUAD)
	
func set_flash(value: float, nodes):
	"""Set the flash value"""
	# Go through each of nodes
	for node in nodes:
		# Make it flash with the given value
		node.material.set_shader_parameter("Progress", value)
