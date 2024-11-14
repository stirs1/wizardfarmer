extends CharacterBody2D

@onready var settings = preload("res://settings.tres")

func _ready():
	# TODO: Set initial start position
	$AnimatedSprite2D.play("pumpkin_walk")
	
func _physics_process(delta):
	# find direction to target and set speed
	var direction = global_position.direction_to(%EnemyTarget.global_position)
	velocity = direction * settings.enemy_pumpkin_speed
	
	# Apply movement
	move_and_slide()
