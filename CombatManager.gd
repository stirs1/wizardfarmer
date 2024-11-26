extends Node

var pumpkin: Node2D
var pumpkin2: Node2D
var pumpkin3: Node2D
var pumpkin4: Node2D

var cm_dtag := "COMBAT MANAGER: "
var pumpkin_start_cell
@onready var PumpkinScene = preload("res://enemy_pumpkin.tscn")
@onready var settings = preload("res://settings.tres")
@onready var enemy_target = get_tree().root.get_node("Main/EnemyTarget")

func _ready():
    await get_tree().root.ready
    GameManager.game_started.connect(_on_game_started)
 
func _on_game_started():
    print(cm_dtag, "signal received!")
    
    # NOTE: copy/pasting the following code does indeed make duplicates, but it
    # doesn't feel like the best way...
    
    # spawns a pumpkin, sets location, direction, and speed
    pumpkin = PumpkinScene.instantiate()
    add_child(pumpkin)
    pumpkin.add_to_group("Enemies")
    pumpkin_start_cell = Vector2(496, 460)
    pumpkin.position = pumpkin_start_cell
    var direction = pumpkin.position.direction_to(enemy_target.global_position)
    pumpkin.velocity = direction * settings.enemy_pumpkin_speed
    
    # spawns the 2nd pumpkin
    pumpkin2 = PumpkinScene.instantiate()
    add_child(pumpkin2)
    pumpkin2.add_to_group("Enemies")
    pumpkin_start_cell = Vector2(656, 305)
    pumpkin2.position = pumpkin_start_cell
    direction = pumpkin2.position.direction_to(enemy_target.global_position)
    pumpkin2.velocity = direction * settings.enemy_pumpkin_speed
    
    # spawns the 3rd pumpkin
    pumpkin3 = PumpkinScene.instantiate()
    add_child(pumpkin3)
    pumpkin3.add_to_group("Enemies")
    pumpkin_start_cell = Vector2(337, 304)
    pumpkin3.position = pumpkin_start_cell
    direction = pumpkin3.position.direction_to(enemy_target.global_position)
    pumpkin3.velocity = direction * settings.enemy_pumpkin_speed
    
    # spawns the 4th pumpkin
    pumpkin4 = PumpkinScene.instantiate()
    add_child(pumpkin4)
    pumpkin4.add_to_group("Enemies")
    pumpkin_start_cell = Vector2(496, 141)
    pumpkin4.position = pumpkin_start_cell
    direction = pumpkin4.position.direction_to(enemy_target.global_position)
    pumpkin4.velocity = direction * settings.enemy_pumpkin_speed
   
