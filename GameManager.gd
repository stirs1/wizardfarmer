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
@onready var game_over_box = get_tree().root.get_node("Main/GameOverText")

# setter that, when anything changes is_paused, sets the new value to either 
# true or false, then pauses the whole tree, then emits the signal.
var is_paused: bool = false:
	set(value):
		is_paused = value
		get_tree().paused = value
		game_paused.emit(value)

func _ready(): 
	# this makes sure this script always runs  
	process_mode = Node.PROCESS_MODE_ALWAYS
	is_paused = true
	await get_tree().root.ready
	
func start_game():
	current_state = GameState.PLAYING
	is_paused = false
	game_over_box.hide()
	game_started.emit()
	
func restart_game():
	current_state = GameState.PLAYING
	is_paused = false
	game_restarted.emit()
	
func prompt_game_over():
	current_state = GameState.GAME_OVER
	is_paused = false
	game_over_box.show()
	game_over.emit()

func pause_game():
	current_state = GameState.PAUSED
	is_paused = true

func unpause_game():
	current_state = GameState.PLAYING
	is_paused = false
	
func _unhandled_input(event):
	
	# press ` to pause, also changes the state
	if event.is_action_pressed("pause"):
		if current_state == GameState.PLAYING:
			pause_game()
		elif current_state == GameState.PAUSED:
			unpause_game()
		print(gm_dtag, "Debug key pressed! Current pause state: ", is_paused)
		print(gm_dtag, "Game is now: ", "paused" if is_paused else "unpaused")
	
	# press 1 to start
	if event.is_action_pressed("start"):
		start_game()

func _physics_process(delta):
	# feel like this is an overly complex way to reference this variable?
	if CombatManager.heart_home.heart_home_health <= 0:
		prompt_game_over()
