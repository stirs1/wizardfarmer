# FIXME: game crashes when non-grape plant is attempted to plant
extends Node

@onready var plant_pots = get_tree().get_nodes_in_group("PlantPots")

var is_plant_here = false 
var held_plant = null

func drop_plant():
	
	# snaps plant to the grid when placed
	held_plant.position = (Global.snap_to_grid(
		Global.wizard_position) - Vector2(
			Global.TILE_SIZE, Global.TILE_SIZE))
	
	# stores position as string 
	var held_plant_position_str = str(held_plant.position)
	
	# places plant if allowed to
	if held_plant_position_str in Global.existing_dirt_tiles:
		if not held_plant_position_str in Global.existing_plant_tiles:
			if not held_plant_position_str in Global.no_grow_zones:
				Global.existing_plant_tiles[str(held_plant.position)] = true
				# set held plant visible above wizard
				held_plant.z_index = 3
				# start held plant timer
				if held_plant.get("timer"):
					held_plant.timer.start()
				else:
					pass
				# start held plant stage timer
				if held_plant.get("stage_timer"):
					held_plant.stage_timer.start()
				else:
					pass
				# add plant to current plants, for future use
				held_plant.add_to_group("CurrentPlants")
				# place plant
				held_plant = null
				return
			else:
				print("this is a no-grow zone!")
				return
		else:
			print("there is already a plant here!")
			return
	else:
		print("this tile needs to be tilled!")
		return
			
func pick_up_plant():
	
	# assign each plant type a position
	for plant in plant_pots:
		
		var plant_position = Global.snap_to_grid(plant.position)
		
		if Global.snap_to_grid(Global.wizard_position) == plant_position:
			held_plant = plant.duplicate()
			held_plant.position = Global.wizard_position
			held_plant.z_index = 100
			add_child(held_plant)

func process_pick_place():
	if Input.is_action_just_pressed("pick_place"):
		if held_plant:
			drop_plant()
		else:
			pick_up_plant()
			
	if held_plant:
		held_plant.position = Global.wizard_position
