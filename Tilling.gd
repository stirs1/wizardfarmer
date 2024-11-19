extends Node

func _ready():
	
	if Global.DirtScene:
		print("Dirt scene loaded successfully")
	else:
		print("Failed to load dirt scene")

# places dirt at the set position        
func place_dirt(position: Vector2) -> StaticBody2D:
	
	#loads the dirt scene as a variable
	var dirt = Global.DirtScene.instantiate()
	
	# assigns dirt to the position of the wizard, snapping it to the grid
	dirt.position = Global.snap_to_grid(
		Global.wizard_position - Vector2(
			Global.tile_size, Global.tile_size)
			)
	# debug - checking where dirt thinks it's going
	print("placing dirt at ", dirt.position)
   
	# sets the parent as the correct dirt tile
	var parent = get_tree().root.get_node("Main/dirt")
	
	# defines str(dirt.position) as its own variable
	var position_str = str(dirt.position)
	
	# checks if there is already a dirt instance there, and only places an 
	# instance if there isn't. then stores the dirt's position as a string
	# in a dictionary to "remember" there's a tile there
	if not position_str in Global.existing_dirt_tiles:
		if not position_str in Global.no_grow_zones:
			parent.add_child(dirt)
			Global.existing_dirt_tiles[str(dirt.position)] = true
			
			# debug to check if dict got new tiles
			#for key in Global.existing_dirt_tiles.keys():
				#var value = Global.existing_dirt_tiles[key]
				#print("Key:", key, "Value: ", value)
	
	# not quiiite sure what this means? just that the function gives a dirt
	# instance back when called? idk but shit works with it
			return dirt
		
		else: # debug
			print("this is a no grow zone!")
			return
		
	else: #debug 
		print("there is already dirt here!")
		return 

# not sure i even need this but keeping it here til script is done
func _physics_process(delta: float) -> void:   
	null
