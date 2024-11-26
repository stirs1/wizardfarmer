extends Area2D

@onready var settings = preload("res://settings.tres")
@onready var heart_home_health = settings.heart_home_health
@onready var heart_home_sprite = $HeartHome_Sprites
@onready var heart_home_collision_box = $HeartHome_CollisionShape2D
@onready var Enemies = get_tree().get_nodes_in_group("Enemies")

var h_dtag := "HEART HOME: "

# FIXME: working on todo
func _ready():   
	body_entered.connect(_on_enemy_entered)
			
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

# FIXME: working on todo
func _on_enemy_entered(body):
	if body.is_in_group("Enemies"):
		heart_home_health -= body.damage
		print(h_dtag, "the base just took ", body.damage, "damage!")
		print(h_dtag, "Heart home health remaining: ", heart_home_health)
