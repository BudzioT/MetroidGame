extends Area2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Path of the saw
var path: Path2D
# Follow point of it
var path_follow: PathFollow2D

# Path point variables
@export_category("PathPoint")
# Increment of the path progress
@export var progress_increment: int = 100
# Direction: -1 decrements the progress, 0 stays in place, 1 increments it
@export_range(-1, 1) var direction: int = 1
# Beginning offset of the saw
@export var offset: int = 0


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Initialize the saw"""
	# Grab the saw path and create its follow point
	path = get_children()[-1]
	
	path_follow = PathFollow2D.new()
	# Add it to the path
	path.add_child(path_follow)
	
	# Place the saw at progress indicated by offset
	path_follow.progress = offset
	
func _process(delta):
	"""Process saw's changes over frames"""
	# Update progress of the saw
	path_follow.progress += progress_increment * delta * direction
	position = path_follow.position

func _body_entered(body):
	"""Handle body touching the saw"""
	# If entity is hitable, try to hit it
	if "hit" in body:
		# Deal 10 damage
		body.hit(10, body.get_sprites())
	
