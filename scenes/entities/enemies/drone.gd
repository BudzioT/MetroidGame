extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
var speed: int = 100

# Drone activated flag
var active: bool = false

# Reference to the player
@onready var player = get_tree().get_first_node_in_group("Player")


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""

