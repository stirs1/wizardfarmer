extends CharacterBody2D

# HMM... perfectin is teh enmey of prgres
# SIGNALS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - SIGNALS #
# ENUMS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ENUMS #
enum PlantState {
	LEVEL_1,
	LEVEL_2,
	LEVEL_3
}
# CONSTANTS - - - - - - - - - - - - - - - - - - - - - - - - - - - - CONSTANTS #
# VARIABLES - - - - - - - - - - - - - - - - - - - - - - - - - - - - VARIABLES #
var settings = preload("res://settings.tres")
var timer
var stage_timer
# METHODS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - METHODS #

# initialize
func _ready():
	pass

# real-time processes
func _process(delta: float) -> void:
	pass
