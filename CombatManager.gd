extends Node

var plant_count = 0
var plant_start_cell = Vector2()
var cm_dtag := "COMBAT MANAGER: "
var pumpkin_start_cell
var gmouse_pos = DisplayServer.mouse_get_position()

# grapeshot preview variables
var preview_grapeshot = null
var preview_plant_sprite = null
var is_grape_preview_active = false 

@onready var PumpkinScene = preload("res://enemy_pumpkin.tscn")
@onready var GrapeshotScene = preload("res://plant_grapeshot.tscn")
@onready var settings = preload("res://settings.tres")
@onready var ghost_shader = preload("res://shaders/grapeshot.tres")
@onready var enemy_target = get_tree().root.get_node("Main/EnemyTarget")
@onready var heart_home = get_tree().root.get_node("Main/HeartHome")
@onready var game_over_box = get_tree().root.get_node("Main/GameOverText")

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
	var grapeshot_button = get_tree().root.get_node("Main/PlantButtons/GrapeshotButton")
	
	# enemy pumpkin buttons - signal connections
	left_button.pressed.connect(func(): spawn_pumpkin("left"))
	right_button.pressed.connect(func(): spawn_pumpkin("right"))
	up_button.pressed.connect(func(): spawn_pumpkin("up"))
	down_button.pressed.connect(func(): spawn_pumpkin("down"))
	random_button.pressed.connect(spawn_random_pumpkin)
	all_button.pressed.connect(spawn_all_pumpkins)
	
	# plant buttons - signal connections
	grapeshot_button.pressed.connect(grapeshot_toggle)

var spawn_positions = {
	"left": Vector2(337, 304),
	"right": Vector2(656, 305),
	"up": Vector2(496, 141),
	"down": Vector2(496, 460)
}
func _ready():
	await get_tree().root.ready
	
	# connect signals
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_over.connect(_on_game_over)
	
	# set buttons here
	_setup_buttons()
 
func _process(delta: float) -> void:
	
	# continually assigns preview grapeshot position to mouse
	if preview_grapeshot:
		preview_grapeshot.global_position = get_viewport().get_mouse_position()

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
	print(cm_dtag, "signal received!")
	
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

func place_grape_preview():
	preview_grapeshot = GrapeshotScene.instantiate()
	add_child(preview_grapeshot)
	preview_object(preview_grapeshot)
	preview_grapeshot.z_index = 1005
	print(cm_dtag, "grapeshot button pressed")
	return

func preview_object(plant):
	preview_plant_sprite = plant.get_node("AnimatedSprite2D")
	var preview_plant_shader = ShaderMaterial.new()
	preview_plant_sprite.frame = 0
	preview_plant_shader.shader = ghost_shader
	preview_plant_sprite.material = preview_plant_shader

func remove_grape_preview():
	if preview_plant_sprite:
		preview_plant_sprite.queue_free()
		preview_grapeshot.queue_free()
		preview_plant_sprite = null
		preview_grapeshot = null
		
func grapeshot_toggle():
	is_grape_preview_active = !is_grape_preview_active
	if is_grape_preview_active:
		place_grape_preview()
	else:
		remove_grape_preview()
