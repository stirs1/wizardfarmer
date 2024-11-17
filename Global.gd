extends Node

# grid alignment tools
const tile_size  = 32 
const tile_offset = tile_size / 2

# preloads
@onready var WizardScene = preload("res://wizard.tscn") 
@onready var DirtScene = preload("res://dirt.tscn")
@onready var PlantPots = get_tree().get_nodes_in_group("PlantPots")
# not sure this is what i want here, keeping for now
#@onready var PlantGrapeshotArea2D = get_tree().root.get_node(
    #"Main/Plant_Grapeshot/Plant_Grapeshot_Area2D")
@onready var settings = preload("res://settings.tres")

# defined containers assigned to their correct type
var existing_dirt_tiles = {}
var no_grow_zones = {}  

# defined global variables assigned to their correct type
var wizard_position = Vector2()
var wizard_cell_position =Vector2()
var wizard = Node2D
var dirt = Node2D
var start_cell = Vector2()
var plant_start_cell = Vector2()
var heart_home = Vector2()
var plant_count = 0

# FIXME: doesn't always do what i want and i don't know why
func snap_to_grid(position: Vector2) -> Vector2:
    var new_position = Vector2.ZERO
    new_position.x = (
        (round(position.x / tile_size) * tile_size) + tile_offset
        )
    new_position.y = (
        (round(position.y / tile_size) * tile_size) + tile_offset
        )
    return new_position

func _ready():
    
    await get_tree().root.ready # makes sure to wait for tree to be loaded?
        
    # adds the wizard to the scene, ai helped with this so idk what's goin on
    wizard = get_tree().root.get_node("Main/wizard")
    if not wizard:
        wizard = WizardScene.instantiate()
        add_child(wizard)
        print("Created new wizard instance")
     
    # set wizard start cell right here. 
    # FIXME: something weird happening with the wizard's origin point
    start_cell = snap_to_grid(
        Vector2(7 * tile_size, 7 * tile_size)) + Vector2(13, 13
        )

    # this makes sure the wizard is on the correct cell AND centered
    wizard.position = start_cell 
    
    # setting plant positions
    # room here for improvement/more robust logic
    for plant in Global.PlantPots:
        plant_start_cell = snap_to_grid(
            Vector2(6 * tile_size, (6 + plant_count) * tile_size))
        plant.position = plant_start_cell + (Vector2(0, tile_size))
        plant_count += 1 
        
    # this defines the no grow zones. This is hard-coded, but i think there's a
    # way to just loop from starting coordinates to end by adding tile_size?
    no_grow_zones = {
        
        # zone 1
        "(368, 304)": "true",
        "(400, 304)": "true",
        "(432, 304)": "true",
        "(464, 304)": "true",
        
        # zone 2
        "(528, 304)": "true",
        "(560, 304)": "true",
        "(592, 304)": "true",
        "(624, 304)": "true",
        
        # zone 3
        "(496, 176)": "true",
        "(496, 208)": "true",
        "(496, 240)": "true",
        "(496, 272)": "true",
        
        # zone 4
        "(496, 336)": "true",
        "(496, 368)": "true",
        "(496, 400)": "true",
        "(496, 432)": "true",
        
        # heart home
        "(496, 304)": "true",
        
        # plant origins
        "(208, 240)": "true",
        "(208, 272)": "true",
        "(208, 304)": "true",
        "(208, 336)": "true"
    }
    
func _physics_process(delta: float) -> void:
    
    # defining wizard global position and grid coordinates
    wizard_position = wizard.global_position
    wizard_cell_position = round(wizard_position / tile_size)
    
    #check to see if wizard position is updating
    #print(wizard_position)
    #print(wizard_cell_position)
