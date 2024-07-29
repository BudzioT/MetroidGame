extends AnimatedSprite2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _animation_finished():
	"""Destroy the explosion effect after it ends"""
	queue_free()
