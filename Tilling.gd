extends Node

var t_dtag := "TILL ACTION: "

func _ready():
	
	if Global.DirtScene:
		print(t_dtag, "Dirt scene loaded successfully")
	else:
		print(t_dtag, "Failed to load dirt scene")
		
func place_dirt(tile: Vector2):
	
	var dirt = Global.DirtScene.instantiate()
	dirt.position = Global.snap_to_grid(
		tile - Vector2(
			Global.TILE_SIZE, Global.TILE_SIZE)
			)
	# debug
	print(t_dtag, "placing dirt at ", dirt.position)
   
	var parent = get_tree().root.get_node("Main/dirt")
	var position_str = str(dirt.position)
	
	# checks if there is already a dirt instance there, and only places an 
	# instance if there isn't. then stores the dirt's position as a string
	# in a dictionary to "remember" there's a tile there
	if not position_str in Global.existing_dirt_tiles:
		if not position_str in Global.no_grow_zones:
			parent.add_child(dirt)
			dirt.set_water_level(0)
			dirt.add_to_group("DirtTiles")
			Global.existing_dirt_tiles[str(dirt.position)] = true
			return dirt
		
		else: # debug
			print(t_dtag, "this is a no grow zone!")
			return
		
	else: #debug 
		print(t_dtag, "there is already dirt here!")
		return 
