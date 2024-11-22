extends State
class_name StateJumpSquat

# This is the logic that runs each frame.
func state_logic(delta:float) -> void:
	super.state_logic(delta)

# This function returns null when there is no transition to occur and the next state's name as a string when there is.
func get_transition(delta:float):
	#	Inheritable transitions
	var next_state = super.get_transition(delta)
	if next_state != null:
		return next_state
	
	if parent.frames >= parent.jumpsquat_frames:
		if Input.is_action_pressed("Jump"):
			parent.velocity.y = -parent.fullhop_v
		else:
			parent.velocity.y = -parent.shorthop_v
		return "StateFall"

# These functions execute whenever the state transitions
func enter_state(old_state:State):
	super.enter_state(old_state)
	#anim.scale.y *= 0.7
	anim.play("jumpsquat")

func exit_state(new_state:State):
	#anim.scale.y /= 0.7
	super.exit_state(new_state)
