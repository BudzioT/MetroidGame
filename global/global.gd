extends Node


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Enumerate with guns that player is able to use
enum weapons { AK, SG, ROCKET }

# Enemy statistics
const enemy_stats = {
	"Drone": { "speed": 120, "health": 30, "damage": 25},
	"Soldier": { "speed": 80, "health": 80 },
	"Monster": { "health": 300 }
}

# Weapon statistics
const weapon_stats = {
	weapons.AK: {"damage": 20, "speed": 150, 
		"texture": preload("res://graphics/guns/projectiles/default.png")},
		
	weapons.SG: {"damage": 40, "range": 100},
	
	weapons.ROCKET: {"damage": 30, "speed": 100, 
		"texture": preload("res://graphics/guns/projectiles/large.png")}
}

# Data of enemies
var enemy_data: Dictionary = { }
