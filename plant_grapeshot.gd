extends CharacterBody2D

enum PlantState {
	LEVEL_1,
	LEVEL_2,
	LEVEL_3
}

signal key_pressed

var settings = preload("res://settings.tres")
var timer
var stage_timer
var projectile_scene = preload("res://grape_projectile.tscn")
var current_state: PlantState = PlantState.LEVEL_1

# vars for the new function i'm building
var projectile
var projectile_position
var projectile_rotation
var projectile_velocity
var plant_position

@onready var projectile_pool = $Grape_ProjectilePool

# use settings.tres to change this in the inspector
@onready var grape_projectile_speed = settings.grape_projectile_speed
@onready var grape_shot_timer = settings.grape_shoot_timer
@onready var grape_stage_timer = settings.grape_stage_timer

# initialize pool and timer
func _ready():
	initialize_pool(10) # integer changes number of projectiles in pool
	
	# initialize projectile timer
	timer = Timer.new()
	add_child(timer)
	timer.autostart =  false
	timer.wait_time = grape_shot_timer # float changes shoot interval
	timer.timeout.connect(_on_timer_timeout)
	
	# initialize stage timer
	stage_timer = Timer.new()
	add_child(stage_timer)
	stage_timer.autostart = false
	stage_timer.wait_time = grape_stage_timer
	stage_timer.timeout.connect(level_up)
	

	# set animation
	$AnimatedSprite2D.play("LEVEL_1")
	
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
	projectile = get_projectile() 
	projectile_position = projectile.position 
	projectile_rotation = projectile.rotation
	projectile_velocity = projectile.linear_velocity
	plant_position = self.global_position
	
	# TODO: finish code to make a double and triple shot attached to level upgrade
	match current_state:
		PlantState.LEVEL_1:
			spawn_projectile(Vector2.ZERO)
		#PlantState.LEVEL_2:
			#spawn_projectile(Vector2(30, 0))
			#spawn_projectile(Vector2( -30, 0))
	
# TODO: finish code to get offset actually working
func spawn_projectile(offset: Vector2):
	if projectile:
		projectile_position = plant_position + offset
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
func _on_timer_timeout():
	shoot()

# when called changes level to next one, can add new abilities + stats
func level_up() -> void:
	match current_state:
		PlantState.LEVEL_1:
			current_state = PlantState.LEVEL_2
			$AnimatedSprite2D.play("LEVEL_2")
			print("plant is now level 2")
		PlantState.LEVEL_2:
			current_state = PlantState.LEVEL_3
			$AnimatedSprite2D.play("LEVEL_3")
			print("plant is now level 3")
