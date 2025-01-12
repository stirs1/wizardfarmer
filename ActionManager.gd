extends Node

# HMM... perfectin is teh enmey of prgres
# SIGNALS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - SIGNALS #
#signal button_in_use
# ENUMS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ENUMS #
# CONSTANTS - - - - - - - - - - - - - - - - - - - - - - - - - - - - CONSTANTS #
# VARIABLES - - - - - - - - - - - - - - - - - - - - - - - - - - - - VARIABLES #
var am_dtag := "ACTION MANAGER: "
var is_preview_active = false
var tile_preview = null
var mouse_pos
@onready var TileSelectScene = preload("res://tile_select.tscn")
# READY - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - READY #
func _ready():
	await get_tree().root.ready
	setup_action_buttons()
# PROCESS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - PROCESS #
func _process(delta: float) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	if tile_preview:
		tile_preview.global_position = Global.snap_to_grid(
		mouse_pos - Vector2(Global.TILE_OFFSET, Global.TILE_OFFSET)
		)
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

func _unhandled_input(event: InputEvent):
	if is_preview_active and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Tilling.place_dirt(mouse_pos + Vector2(
				Global.TILE_OFFSET, Global.TILE_OFFSET)
				)
