extends CharacterBody2D

@export var speed = 100  # Movement speed in pixels/second
@export var movement_range = 200  # How far the enemy moves left/right from start position
var start_position: Vector2
var moving_down = true

func _ready():
    # Store the initial position
    start_position = position
    $AnimatedSprite2D.play("pumpkin_walk")
    
func _physics_process(delta):
    # Calculate horizontal movement
    var velocity_y = speed if moving_down else -speed
    velocity.y = velocity_y
    
    # Check if we need to change direction
    if moving_down and position.y >= start_position.y + movement_range:
        moving_down = false
        speed = 0
        $AnimatedSprite2D.play("idle")
        
    #elif not moving_right and position.x <= start_position.x - movement_range:
        #moving_right = true
    
    # Apply movement
    move_and_slide()
