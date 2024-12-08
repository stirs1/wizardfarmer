extends CharacterBody2D

# HMM... perfectin is teh enmey of prgres
# SIGNALS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - SIGNALS #
signal wsource_entered
signal wdrop_collected
signal wdrop_dropped
signal wtask_completed
# ENUMS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ENUMS #
enum WPlopState {
	IDLE,
	SEEKING_WATER,
	COLLECTING_WATER,
	SEEKING_TILE,
	DROPPING_WATER 
	}
# CONSTANTS - - - - - - - - - - - - - - - - - - - - - - - - - - - - CONSTANTS #
const MAGICAL_AWARENESS_RADIUS := 100.0
const ARRIVAL_THRESHOLD := 10.0
# VARIABLES - - - - - - - - - - - - - - - - - - - - - - - - - - - - VARIABLES #
var existing_water_tiles = {}
var existing_dirt_tiles = {}
var dry_tiles = []
var wdrop: PackedScene
var held_wdrop: Node2D
var current_target: Vector2
var is_carrying_water: bool
var current_state: WPlopState = WPlopState.IDLE
# METHODS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - METHODS #

# initialize
func _ready():
	pass

# state machine for autonomous behavior
func _process(delta: float) -> void:
	match current_state: 
		WPlopState.IDLE:
			current_target = find_nearest_wsource()
			if current_target:
				current_state = WPlopState.SEEKING_WATER
	
		WPlopState.SEEKING_WATER:
			move_to_target(delta)
			if position.distance_to(current_target) < ARRIVAL_THRESHOLD:
					emit_signal("wsource_entered")
					current_state = WPlopState.COLLECTING_WATER
		
		WPlopState.COLLECTING_WATER:
			collect_wdrop()
			is_carrying_water = true
			current_target = find_nearest_dtile()
			current_state = WPlopState.SEEKING_TILE
		
		WPlopState.DROPPING_WATER:
			drop_water()
			is_carrying_water = false
			emit_signal("wtask_completed")
			current_state = WPlopState.IDLE
	
# find closest water source
func find_nearest_wsource():
	pass

# instance new water drop
func collect_wdrop():
	wdrop_collected.emit()
	pass

# find closest available dry tile
func find_nearest_dtile():
	pass

# mark tile as "targeted" so other drops don't go there
func reserve_dtile():
	pass

# place water and update tile states
func drop_water():
	wdrop_dropped.emit()
	pass

# movement helper function?
func move_to_target(delta: float) -> void:
	pass
