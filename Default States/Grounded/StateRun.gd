extends StateGrounded
class_name StateRun

# This is the logic that runs each frame.
func state_logic(delta:float) -> void:
	#super.state_logic(delta)
	
	parent.velocity.x = move_toward(parent.velocity.x, controller.x_axis() * parent.run_speed, parent.ground_acceleration)

# This function returns null when there is no transition to occur and the next state's name as a string when there is.
func get_transition(delta:float):
	#	Inheritable transitions
	var next_state = super.get_transition(delta)
	if next_state != null:
		return next_state
	
	if not controller.x_axis():
		return "StateWalk"

# These functions execute whenever the state transitions
func enter_state(old_state:State):
	super.enter_state(old_state)
	anim.play("run")

func exit_state(new_state:State):
	super.exit_state(new_state)