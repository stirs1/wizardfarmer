extends CharacterBody2D

var settings = preload("res://settings.tres")

# use settings.tres to change this in the inspector
@onready var grape_projectile_speed = settings.grape_projectile_speed

# loading projectile pool child
@onready var projectile_pool = $Grape_ProjectilePool

# load projectile scene
var grape_projectile_scene = preload("res://grape_projectile.tscn")

func _ready():
    initialize_pool(10)  # Initialize with 10 projectiles

func _input(event):
    if event.is_action_pressed("shoot"):  # Define this input action in Project Settings
        shoot()


func initialize_pool(pool_size: int): # initialize pool has a custom parameter - pool_size - which is an integer
    for i in pool_size: # define variable i, and for every i in the pool size, run this code
        var projectile = grape_projectile_scene.instantiate() # define projectile and assign it as an instantiated grape projectile scene
        projectile_pool.add_child(projectile) # places the projectile into the game world, specificlaly the projectile pool
        projectile.hide() # makes the projectile invisible
        projectile.returned.connect(_on_projectile_returned)  # Custom signal, not sure what this does
        projectile.add_to_pool() # not sure what this does, but it's connected to the projectile

func shoot():
    var projectile = get_projectile() # loads the get projectile function here (lambda? callable?)
    if projectile: # if projectile exists/is true,
        projectile.position = global_position # sets the position to global_position (what global_position? the plant??)
        projectile.rotation = rotation # sets the projectile rotation to plant's rotation
        projectile.linear_velocity = Vector2.RIGHT.rotated(rotation) * grape_projectile_speed # takes projectile's linear velocity and rotates it to the right, giving it a speed of shoot speed which i think i can connect to the export?
        projectile.show() # makes the projectile visible

func get_projectile() -> Node2D: # a function that retrieves projectiles from the pool
    # Look for an inactive projectile in the pool
    for projectile in projectile_pool.get_children(): # for every projectile in the pool (found in the retrieved array)
        if not projectile.visible: # if the projectile is not visible? not sure this is even a thing, need to check
            return projectile # sends a projectile instance basically?
    return null

func _on_projectile_returned(projectile: Node2D): # a function that runs when projectile is returned to the pool
    projectile.hide() # hides the projectile instance
    projectile.linear_velocity = Vector2.ZERO # stops the projectile from moving
