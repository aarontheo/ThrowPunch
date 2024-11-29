extends State
#THIS IS A BASE STATE, YOU SHOULDN'T BE IN THIS STATE!
class_name StateGrounded

# This is the logic that runs each frame.
func state_logic(delta:float) -> void:
	super.state_logic(delta)
	
	#parent.velocity.x = move_toward(parent.velocity.x, 0, parent.traction)
	if abs(parent.velocity.x) >= parent.min_speed:
		parent.velocity.x *= parent.friction
	else:
		parent.velocity.x = 0
	
	if controller.y_axis() > 0.3:
		parent.disable_platform_collision()

# This function returns null when there is no transition to occur and the next state's name as a string when there is.
func get_transition(delta:float):
	#	Inheritable transitions
	var next_state = super.get_transition(delta)
	if next_state != null:
		return next_state
	
	if not parent.is_on_floor():
		return "StateFall"
	if input.is_action_press_buffered("Jump"):
		return "StateJumpSquat"

# These functions execute whenever the state transitions
func enter_state(old_state:State):
	super.enter_state(old_state)

func exit_state(new_state:State):
	super.exit_state(new_state)
	parent.enable_platform_collision()
