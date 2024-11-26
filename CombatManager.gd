extends Node

var pumpkin: Node2D
var cm_dtag := "COMBAT MANAGER: "
@onready var PumpkinScene = preload("res://enemy_pumpkin.tscn")

func _ready():
	await get_tree().root.ready
	print(cm_dtag, "Connecting to game_started signal...")
	GameManager.game_started.connect(_on_game_started)
	print(cm_dtag, "Connected!")

func _on_game_started():
	print(cm_dtag, "running _on_game_started...")
	var main = get_tree().root
	if main:
		print(cm_dtag, "main exists")
		pumpkin = PumpkinScene.instantiate()
		print(cm_dtag, "pumpkin instantiated")
		main.add_child.call_deferred(pumpkin)  # using call_deferred to be safe
		pumpkin.position = Vector2(400, 400)
		print(cm_dtag, "pumpkin instance created at ", pumpkin.position)
	else:
		print(cm_dtag, "main not found")
	
