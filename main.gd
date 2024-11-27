extends Node2D

var m_tag := "MAIN: "

func _ready():
	pass
 
# debugging from main node   
func _unhandled_input(event: InputEvent) -> void:
	
	# get readable scene tree (not when game is paused tho)
	if event.is_action_pressed("debug"):
		var tree = get_tree_string_pretty()
		print(tree)
