# TODO: update health frames to match 0/25/50/75/100 heart home health
# TODO: assign health and the ability to die  
extends Area2D

@onready var settings = preload("res://settings.tres")
@onready var heart_home_health = settings.heart_home_health
@onready var Enemies = get_tree().get_nodes_in_group("Enemies")
