# TODO: assign health and the ability to die  
extends Area2D

@onready var settings = preload("res://settings.tres")
@onready var heart_home_health = settings.heart_home_health
@onready var Enemies = get_tree().get_nodes_in_group("Enemies")
@onready var heart_home_sprite = $HeartHome_Sprites

func _ready():
    pass
            
func _process(delta: float) -> void:
    
    # set heart home sprite based on current health
    if heart_home_health >= 76 and heart_home_health <= 100:
        heart_home_sprite.frame = 0
    elif heart_home_health >= 51 and heart_home_health <= 76:
        heart_home_sprite.frame = 1
    elif heart_home_health >= 26 and heart_home_health <= 51:
        heart_home_sprite.frame = 2
    elif heart_home_health > 0  and heart_home_health <= 26:
        heart_home_sprite.frame = 3
    elif heart_home_health <= 0:
        heart_home_sprite.frame = 4
