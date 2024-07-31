extends AnimatedSprite2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the explosion"""
	# Play sound effect
	$ExplosionSound.play()

func _animation_finished():
	"""Destroy the explosion effect after it ends"""
	queue_free()
