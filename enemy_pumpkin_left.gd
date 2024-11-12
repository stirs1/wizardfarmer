extends CharacterBody2D

@export var speed = 100  # Movement speed in pixels/second
@export var movement_range = 200  # How far the enemy moves left/right from start position
var start_position: Vector2
var moving_right = true

func _ready():
    # Store the initial position
    start_position = position
    $AnimatedSprite2D.play("pumpkin_walk")
    
func _physics_process(delta):
    # Calculate horizontal movement
    var velocity_x = speed if moving_right else -speed
    velocity.x = velocity_x
    
    # Check if we need to change direction
    if moving_right and position.x >= start_position.x + movement_range:
        moving_right = false
        speed = 0
        $AnimatedSprite2D.play("idle")
        
    #elif not moving_right and position.x <= start_position.x - movement_range:
        #moving_right = true
    
    # Apply movement
    move_and_slide()

func nothing():
    pass

func more_nothing():
    pass
