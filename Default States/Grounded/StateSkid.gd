extends StateGrounded
class_name StateSkid

# This is the logic that runs each frame.
func state_logic(delta:float) -> void:
	super.state_logic(delta)

# This function returns null when there is no transition to occur and the next state's name as a string when there is.
func get_transition(delta:float):
	#	Inheritable transitions
	var next_state = super.get_transition(delta)
	if next_state != null:
		return next_state

# These functions execute whenever the state transitions
func enter_state(old_state:State):
	super.enter_state(old_state)

func exit_state(new_state:State):
	super.exit_state(new_state)
