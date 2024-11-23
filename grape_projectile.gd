extends Area2D

var linear_velocity = Vector2.ZERO
var projectile_damage = 10

signal returned(projectile) 

# defines functions for adding and returning projectiles upon collision
func _ready():
	body_entered.connect(_on_body_entered) 
	
func _physics_process(delta):
	position += linear_velocity * delta  
	
func add_to_pool():
	hide() 
	linear_velocity = Vector2.ZERO 
	position = Vector2.ZERO
	
func _on_body_entered(_body):
	linear_velocity = Vector2.ZERO
	returned.emit(self)
	add_to_pool()

func get_projectile_damage():
	null
