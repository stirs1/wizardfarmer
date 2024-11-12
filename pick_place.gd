extends Node

@onready var plant_pots = get_tree().get_nodes_in_group("PlantPots")

var is_plant_here = false 
var held_plant = null

func drop_plant():
    held_plant.position = (Global.snap_to_grid(
        Global.wizard_position) - Vector2(
            Global.tile_size, Global.tile_size)
            )
    held_plant.z_index = 3
    held_plant = null

func pick_up_plant():
    
    # assign each plant type a position
    for plant in plant_pots:
        var plant_position = Global.snap_to_grid(plant.position)
        print(plant_position)
        
        if Global.snap_to_grid(Global.wizard_position) == plant_position:
            held_plant = plant.duplicate()
            held_plant.position = Global.wizard_position
            held_plant.z_index = 100
            add_child(held_plant)

# call this to use the whole pick place input action
func process_pick_place():
    if Input.is_action_just_pressed("pick_place"):
        if held_plant:
            drop_plant()
        else:
            pick_up_plant()
            
    # set plant position to the wizard position - WIP -
    if held_plant:
        held_plant.position = Global.wizard_position
