extends Node

#var pumpkin: Node2D
var cm_dtag := "COMBAT MANAGER: "

#@onready var PumpkinScene = preload("res://enemy_pumpkin.tscn")

func _ready():
    await get_tree().root.ready
    GameManager.game_started.connect(_on_game_started)
 
func _on_game_started():
    print(cm_dtag, "signal received!")
    
