extends State
class_name StateFall

var fast_falling = false
var prev_y_axis: float = 0

# This is the logic that runs each frame.
func state_logic(delta:float) -> void:
	super.state_logic(delta)
	
	# Allow for aerial jumps
	if parent.aerial_jumps > 0:
		if InputBuffer.is_action_press_buffered("Jump"):
			parent.velocity.y = -parent.aerial_jump_v
			parent.aerial_jumps -= 1
	
	# Allow movement side to side
	parent.velocity.x = move_toward(
		parent.velocity.x, 
		parent.max_airspeed*controller.x_axis(),
		parent.air_acceleration)
	# Logic for fast falling
	if fast_falling:
		parent.velocity.y = parent.fast_fall_speed
	else:
		parent.velocity.y = move_toward(parent.velocity.y, 	parent.fall_speed, parent.gravity * delta)

# This function returns null when there is no transition to occur and the next state's name as a string when there is.
func get_transition(delta:float):
	#	Inheritable transitions
	var next_state = super.get_transition(delta)
	if next_state != null:
		return next_state

	# Detect fast falling input (downward stick flick)
	if parent.velocity.y >= 0 and controller.y_axis() > 0 and InputBuffer.is_action_press_buffered("Flick_v"):
		fast_falling = true
	
	if parent.is_on_floor():
		return "StateLanding"

# These functions execute whenever the state transitions
func enter_state(old_state:State):
	super.enter_state(old_state)
	anim.play("fall")

func exit_state(new_state:State):
	fast_falling = false
	super.exit_state(new_state)
	if new_state is StateGrounded:
		parent.aerial_jumps = parent.aerial_jump_count
