# FIXME: when plant passes over enemy pumpkin, all projectiles damage it and
# and immediately kill it.

extends CharacterBody2D

@onready var settings = preload("res://settings.tres")
@onready var enemy_target = get_tree().root.get_node("Main/EnemyTarget")
@onready var Projectiles = get_tree().get_nodes_in_group("Projectiles")

@onready var health = settings.enemy_pumpkin_health
@onready var damage = settings.enemy_pumpkin_damage

var new_health: int = 0
var projectile_count: int = 0

func _ready():
	# TODO: Set initial start position
	$AnimatedSprite2D.play("pumpkin_walk")

func _physics_process(delta):

	var direction = global_position.direction_to(%EnemyTarget.global_position)
	velocity = direction * settings.enemy_pumpkin_speed
	
	# TODO: if velocity = 0, play idle animation (this doesn't work currently)
	#if settings.enemy_pumpkin_speed <= 0:
		#$AnimatedSprite2D.play("idle")
	
	# Apply movement
	move_and_slide()
	
func _on_enemy_pumpkin_collision_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectiles"):
		
		# DEBUG
		print("pumpkin hit by: ", area)
		print("pumpkin health before hit: ", health)
		print("pumpkin new_health before hit: ", new_health)
		
		new_health = health - area.projectile_damage
		
		# DEBUG
		print("pumpkin new_health after hit: ", new_health)
		
		health = new_health
		
		#DEBUG
		print("health after all the calculations: ", health)
		
		# kill the enemy
		if health <= 0:
			queue_free()
