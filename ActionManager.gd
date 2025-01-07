extends Node

# HMM... perfectin is teh enmey of prgres
# SIGNALS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - SIGNALS #
# ENUMS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ENUMS #
# CONSTANTS - - - - - - - - - - - - - - - - - - - - - - - - - - - - CONSTANTS #
# VARIABLES - - - - - - - - - - - - - - - - - - - - - - - - - - - - VARIABLES #
var am_dtag := "ACTION MANAGER: "
var is_preview_active = false
var tile_preview = null
@onready var mouse_pos = get_viewport().get_mouse_position()
@onready var TileSelectScene = preload("res://tile_select.tscn")
# READY - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - READY #
func _ready():
	await get_tree().root.ready
	setup_action_buttons()
# PROCESS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - PROCESS #
func _process(delta: float) -> void:
	if tile_preview:
		tile_preview.global_position = get_viewport().get_mouse_position()
# METHODS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - METHODS #
func setup_action_buttons():
	var till_button = get_tree().root.get_node("Main/ActionButtons/TillButton")
	till_button.pressed.connect(till_toggle)

func till_toggle():
	is_preview_active = !is_preview_active
	if is_preview_active:
		show_tile_preview()
	else:
		hide_tile_preview()

func show_tile_preview():
	tile_preview = TileSelectScene.instantiate()
	add_child(tile_preview)
	tile_preview.z_index = 1005
	print(am_dtag, "till button toggled")
	return

func hide_tile_preview():
	if tile_preview:
		tile_preview.queue_free()
		tile_preview = null
