extends StateGrounded
class_name StateDash

# This is the logic that runs each frame.
func state_logic(delta:float) -> void:
	if not controller.x_axis():
		super.state_logic(delta)

# This function returns null when there is no transition to occur and the next state's name as a string when there is.
func get_transition(delta:float):
	#	Inheritable transitions
	var next_state = super.get_transition(delta)
	if next_state != null:
		return next_state

	#if InputBuffer.is_action_press_buffered("Flick_h") and sign(Controller.x_axis()) != sign(parent.velocity.x):
		#return "StateDash"

	if parent.frames >= parent.dash_frames:
		if sign(controller.x_axis()) == sign(parent.velocity.x):
			return "StateRun"
		else:
			return "StateIdle"

func enter_state(old_state:State):
	parent.velocity.x = parent.dash_speed * sign(controller.x_axis())
	anim.play("run")

func exit_state(new_state:State):
	pass
