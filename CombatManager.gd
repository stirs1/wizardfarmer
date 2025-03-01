extends Node

# HMM... perfectin is teh enmey of prgres
# SIGNALS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - SIGNALS #
# ENUMS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ENUMS #
# CONSTANTS - - - - - - - - - - - - - - - - - - - - - - - - - - - - CONSTANTS #
# VARIABLES - - - - - - - - - - - - - - - - - - - - - - - - - - - - VARIABLES #
var spawn_positions = {
	"left": Vector2(337, 304),
	"right": Vector2(656, 305),
	"up": Vector2(496, 141),
	"down": Vector2(496, 460)
	}
var plants = {
	"grapeshot": preload("res://plant_grapeshot.tscn"),
	"gourdie": preload("res://plant_gourdie.tscn"),
	"strawjerry": preload("res://plant_strawjerry.tscn"),
	"aquaclam": preload("res://plant_aquaclam.tscn")
	}
var plant_count = 0
var plant_start_cell = Vector2()
var cm_dtag := "COMBAT MANAGER: "
var pumpkin_start_cell
# grapeshot preview variables
var preview_plant = null
var preview_plant_sprite = null
var is_plant_preview_active = false 
var gmouse_pos: Vector2 = Vector2.ZERO
var parent
var plant_position_str
var current_plant_type: String = ""
@onready var PumpkinScene = preload("res://enemy_pumpkin.tscn")
@onready var GrapeshotScene = preload("res://plant_grapeshot.tscn")
@onready var settings = preload("res://settings.tres")
@onready var ghost_shader = preload("res://shaders/grapeshot.tres")
@onready var enemy_target = get_tree().root.get_node("Main/EnemyTarget")
@onready var heart_home = get_tree().root.get_node("Main/HeartHome")
@onready var game_over_box = get_tree().root.get_node("Main/GameOverText")
# READY - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - READY #
func _ready():
	await get_tree().root.ready
	# connect signals
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_game_over)
	# set buttons here
	_setup_buttons()
# PROCESS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - PROCESS #
func _process(delta: float) -> void:
	# continually assigns preview grapeshot position to mouse
	if preview_plant:
		gmouse_pos = get_viewport().get_mouse_position()
		preview_plant.global_position = Global.snap_to_grid(
		gmouse_pos - Vector2(Global.TILE_OFFSET, Global.TILE_OFFSET)
		)
# METHODS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - METHODS #
# allows buttons to be set up at once at the correct time in the process
func _setup_buttons():
	# enemy pumpkin buttons
	var left_button = get_tree().root.get_node("Main/LeftButton")
	var right_button = get_tree().root.get_node("Main/RightButton")
	var up_button = get_tree().root.get_node("Main/UpButton")
	var down_button = get_tree().root.get_node("Main/DownButton")
	var random_button = get_tree().root.get_node("Main/RandomButton")
	var all_button = get_tree().root.get_node("Main/AllButton")
	# plant buttons
	var grapeshot_button = get_tree().root.get_node(
		"Main/PlantButtons/GrapeshotButton"
		)
	var gourdie_button = get_tree().root.get_node(
		"Main/PlantButtons/GourdieButton"
		)
	var strawjerry_button = get_tree().root.get_node(
		"Main/PlantButtons/StrawjerryButton"
		)
	var aquaclam_button = get_tree().root.get_node(
		"Main/PlantButtons/AquaclamButton"
		)
	# enemy pumpkin buttons - signal connections
	left_button.pressed.connect(func(): spawn_pumpkin("left"))
	right_button.pressed.connect(func(): spawn_pumpkin("right"))
	up_button.pressed.connect(func(): spawn_pumpkin("up"))
	down_button.pressed.connect(func(): spawn_pumpkin("down"))
	random_button.pressed.connect(spawn_random_pumpkin)
	all_button.pressed.connect(spawn_all_pumpkins)
	# plant buttons - signal connections
	grapeshot_button.pressed.connect(func(): toggle_plant_preview("grapeshot"))
	gourdie_button.pressed.connect(func(): toggle_plant_preview("gourdie"))
	strawjerry_button.pressed.connect(func(): toggle_plant_preview("strawjerry"))
	aquaclam_button.pressed.connect(func(): toggle_plant_preview("aquaclam"))
	
func spawn_pumpkin(position_key: String):
	var pumpkin = PumpkinScene.instantiate()
	add_child(pumpkin)
	pumpkin.add_to_group("Enemies")
	pumpkin.position = spawn_positions[position_key]
	var direction = pumpkin.position.direction_to(enemy_target.global_position)
	pumpkin.velocity = direction * settings.enemy_pumpkin_speed

func spawn_random_pumpkin():
	var positions = spawn_positions.keys()
	var random_position = positions[randi() % positions.size()]
	spawn_pumpkin(random_position)
	
func spawn_all_pumpkins():
	for position_key in spawn_positions.keys():
		spawn_pumpkin(position_key)
		
func _on_game_started():
	print(cm_dtag, "signal received!") # DEBUG
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	for plant in get_tree().get_nodes_in_group("CurrentPlants"):
		plant.queue_free()
	for dirt in get_tree().get_nodes_in_group("DirtTiles"):
		dirt.queue_free()
	Global.existing_dirt_tiles.clear()
	Global.existing_plant_tiles.clear()
	plant_count = 0
	heart_home.heart_home_health = 100
	for plant in Global.PlantPots:
		plant_start_cell = Global.snap_to_grid(
			Vector2(6 * Global.TILE_SIZE, (6 + plant_count) * Global.TILE_SIZE))
		plant.position = plant_start_cell + (Vector2(0, Global.TILE_SIZE))
		plant_count += 1 

func _on_game_over():
	game_over_box.show()

func place_plant_preview():
	preview_plant = plants[current_plant_type].instantiate()
	add_child(preview_plant)
	preview_object(preview_plant)
	preview_plant.z_index = 1005
	print(cm_dtag, "plant button pressed") # DEBUG
	return

func preview_object(plant):
	preview_plant_sprite = plant.get_node("AnimatedSprite2D")
	var preview_plant_shader = ShaderMaterial.new()
	preview_plant_sprite.frame = 0
	preview_plant_shader.shader = ghost_shader
	preview_plant_sprite.material = preview_plant_shader

func remove_plant_preview():
	if preview_plant_sprite:
		preview_plant_sprite.queue_free()
		preview_plant.queue_free()
		preview_plant_sprite = null
		preview_plant = null
		current_plant_type = ""
		
func toggle_plant_preview(plant_type):
	if current_plant_type == plant_type:
		is_plant_preview_active = false
		remove_plant_preview()
	else:
		current_plant_type = plant_type
		is_plant_preview_active = true
		if preview_plant:
			remove_plant_preview()
		place_plant_preview()

func place_plant():
	if current_plant_type.is_empty():
		return
	parent = plants[current_plant_type].instantiate()
	parent.position = Global.snap_to_grid(gmouse_pos - Vector2(
		Global.TILE_OFFSET, Global.TILE_OFFSET)
		)
	var plant_position_str = str(parent.position)
	
	if plant_position_str in Global.existing_dirt_tiles:
		if not plant_position_str in Global.existing_plant_tiles:
			if not plant_position_str in Global.no_grow_zones:
				Global.existing_plant_tiles[str(parent.position)] = true
				parent.z_index = 3
				add_child(parent)
				# start held plant timer
				if parent.get("timer"):
					parent.timer.start()
				else:
					pass
				# start held plant stage timer
				if parent.get("stage_timer"):
					parent.stage_timer.start()
				else:
					pass
				# add plant to current plants, for future use
				parent.add_to_group("CurrentPlants")
				# place plant
				parent = null
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

func _unhandled_input(event: InputEvent):
	if is_plant_preview_active and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print(cm_dtag, "left mouse button clicked") # DEBUG
			place_plant()
