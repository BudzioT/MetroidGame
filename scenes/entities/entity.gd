class_name Entity
extends CharacterBody2D


"""---------------------------- SIGNALS ----------------------------"""
signal shoot(position, direction, weapon)


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
var health: int = 100:
	# Setter of the health
	set(value):
		health = value
		
		# If entity has no more health, make it die
		if health <= 0:
			_death()


"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func hit(damage):
	"""Handle getting hit"""
	# If entity isn't invincible, make it take some damage
	if not $Timers/Invincibility.time_left:
		# Decrease the health
		health -= damage
		
		# Make entity unhitable again
		$Timers/Invincibility.start()
	
func _death():
	print("DEATH")
