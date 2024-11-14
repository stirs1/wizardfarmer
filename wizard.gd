extends CharacterBody2D

var speed = 200 # this number changes the wizard's speed
@onready var tile_size


func _ready():
	
	if get_parent().has_node("Plant_Grapeshot"):
		get_parent().get_node("Plant_Grapeshot").key_pressed.connect(_on_key_pressed)
   
func _process(delta: float) -> void: 
	
	# adds the pick up and place pot ability to the wizard - key P
	PickPlace.process_pick_place()
	
	var direction = Vector2.ZERO

	# move right
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
	# move left
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	# move up
	if Input.is_action_pressed("move_up"):
		direction.y -= 1  # Remember y goes negative for upward movement
		
	# move down
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
	# till
	if Input.is_action_just_pressed("till"):
		# debug
		print("the wizard is at cell: " + str(
			Global.wizard_cell_position))
		print("the wizard's global position is: " + str(
			Global.wizard_position))
			
		#tilling action pulled from Tilling singleton
		Tilling.place_dirt(self.position)
		
	# pick up or place - old code (for now)
	#if Input.is_action_just_pressed("pick_place"):
		#PickPlace.pick_up_plant()
		
		#print("pick/place key pressed")
		#if PickPlace.grapeshot:
			#print("is plant loaded: true")
		#if PickPlace.plant_pots:
			#print("is plant_pots loaded: true")
		
		#for plant in Global.PlantPots:
			#print(plant)
			#print(plant.position)
	  
	# sets movement * speed, normalizes it
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()     
	
func _on_key_pressed():
	print("signal received")
