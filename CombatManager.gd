extends Node

var plant_count = 0
var plant_start_cell = Vector2()
var cm_dtag := "COMBAT MANAGER: "
var pumpkin_start_cell

@onready var PumpkinScene = preload("res://enemy_pumpkin.tscn")
@onready var settings = preload("res://settings.tres")
@onready var enemy_target = get_tree().root.get_node("Main/EnemyTarget")
@onready var heart_home = get_tree().root.get_node("Main/HeartHome")
@onready var game_over_box = get_tree().root.get_node("Main/GameOverText")

# allows buttons to be set up at once at the correct time in the process
func _setup_buttons():
	var left_button = get_tree().root.get_node("Main/LeftButton")
	var right_button = get_tree().root.get_node("Main/RightButton")
	var up_button = get_tree().root.get_node("Main/UpButton")
	var down_button = get_tree().root.get_node("Main/DownButton")
	var random_button = get_tree().root.get_node("Main/RandomButton")
	var all_button = get_tree().root.get_node("Main/AllButton")
	
	left_button.pressed.connect(func(): spawn_pumpkin("left"))
	right_button.pressed.connect(func(): spawn_pumpkin("right"))
	up_button.pressed.connect(func(): spawn_pumpkin("up"))
	down_button.pressed.connect(func(): spawn_pumpkin("down"))
	random_button.pressed.connect(spawn_random_pumpkin)
	all_button.pressed.connect(spawn_all_pumpkins)

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
			Vector2(6 * Global.tile_size, (6 + plant_count) * Global.tile_size))
		plant.position = plant_start_cell + (Vector2(0, Global.tile_size))
		plant_count += 1 

func _on_game_over():
	game_over_box.show()
