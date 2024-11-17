extends Node

#@onready var settings = preload("res://settings.tres")
#@onready var enemies = get_tree().get_nodes_in_group("Enemies")

# TODO: write a script

# 1. hear an emitted signal from when a projectile hits the pumpkin. 
# --- is it better if the signal emits from the projectile or the pumpkin?
# --- maybe signal body_entered(
# --- enemy: Node2d, projectile: Node2d, projectile_damage: int
# --- ) on the pumpkin? 
# --- are projectile & projectile damage redundant?

# 2. set new enemy health to enemy health - projectile damage

# 3. if the enemy health is below 0, delete the enemy
# --- maybe this function and variable can go on the pumpkin?

# does this account for all enemy types? or is there an easier way to tackle it?

# NOTE: enemy_pumpkin script code here
