extends Node

# can access when the game is paused from any script using this signal
signal game_paused(is_paused: bool)
signal game_started
signal game_restarted
signal game_over

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var gm_dtag := "GAME MANAGER: "
var current_state: GameState = GameState.PLAYING

# setter that, when anything changes is_paused, sets the new value to either 
# true or false, then pauses the whole tree, then emits the signal.
var is_paused: bool = false:
	set(value):
		is_paused = value
		get_tree().paused = value
		game_paused.emit(value)

# makes sure this script runs even when game is paused. 
# NOTE: i thought autoloads are always on, but i guess not? confuse
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	is_paused = false
	await get_tree().root.ready
	print(gm_dtag, "calling start_game() function")
	start_game()

func start_game():
	current_state = GameState.PLAYING
	is_paused = false
	print(gm_dtag, "about to emit game_started signal")  # debug print
	game_started.emit()
	print(gm_dtag, "Signal emitted!")
	
func restart_game():
	current_state = GameState.PLAYING
	is_paused = false
	game_restarted.emit()
	
func prompt_game_over():
	current_state = GameState.GAME_OVER
	game_over.emit()

func pause_game():
	current_state = GameState.PAUSED
	is_paused = true

func unpause_game():
	current_state = GameState.PLAYING
	is_paused = false
	
func _unhandled_input(event):
	
	#assigns pause to a key and changes the state
	if event.is_action_pressed("pause"):
		if current_state == GameState.PLAYING:
			pause_game()
		elif current_state == GameState.PAUSED:
			unpause_game()
		print(gm_dtag, "Debug key pressed! Current pause state: ", is_paused)
		print(gm_dtag, "Game is now: ", "paused" if is_paused else "unpaused")
	
	#if event.is_action_pressed("start"):
		#start_game()
