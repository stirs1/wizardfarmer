extends CharacterBody2D

signal key_pressed

var settings = preload("res://settings.tres")
var timer
var projectile_scene = preload("res://grape_projectile.tscn")

@onready var projectile_pool = $Grape_ProjectilePool

# use settings.tres to change this in the inspector
@onready var grape_projectile_speed = settings.grape_projectile_speed
@onready var grape_shot_timer = settings.grape_shoot_timer

# initialize pool and timer
func _ready():
	initialize_pool(10) # integer changes number of projectiles in pool
	
	timer = Timer.new()
	add_child(timer)
	timer.autostart =  false
	timer.wait_time = grape_shot_timer # float changes shoot interval
	timer.timeout.connect(_on_Timer_timeout)
	#timer.start()

# create pool and initialize starting state
func initialize_pool(pool_size: int):
	for i in pool_size: 
		var projectile = projectile_scene.instantiate()
		projectile_pool.add_child(projectile) 
		projectile.hide() 
		projectile.returned.connect(_on_projectile_returned) 
		projectile.add_to_pool()

# shoot projectile from plant location
func shoot():
	# this can be simplified
	var projectile = get_projectile() 
	var projectile_position = projectile.position 
	var projectile_rotation = projectile.rotation
	var projectile_velocity = projectile.linear_velocity
	var plant_position = self.global_position
	
	if projectile:
		projectile_position = plant_position
		projectile_rotation = rotation
		projectile.linear_velocity = Vector2.DOWN * grape_projectile_speed 
		projectile_velocity = projectile.linear_velocity
		projectile.show()

# load the projectile to be shot
func get_projectile() -> Node2D: 
	for projectile in projectile_pool.get_children():
		if not projectile.visible:
			return projectile 
	return null

# return projectile to pool upon signal
func _on_projectile_returned(projectile: Node2D):
	projectile.hide()
	projectile.linear_velocity = Vector2.ZERO
	projectile.add_to_pool()

# shoot projectile every timeout
func _on_Timer_timeout():
	shoot()
