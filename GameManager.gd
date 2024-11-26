extends Node

# can access when the game is paused from any script using this signal
signal game_paused(is_paused: bool)

var gm_dtag := "GAME MANAGER: "
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

# assigns pause to a key
func _unhandled_input(event):
    if event.is_action_pressed("pause"):
        print(gm_dtag, "Debug key pressed! Current pause state: ", is_paused)
        is_paused = !is_paused
        print(gm_dtag, "Game is now: ", "paused" if is_paused else "unpaused")
