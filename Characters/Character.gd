extends CharacterBody2D
class_name Character

#region Movement Stats
####################
## MOVEMENT STATS ##
####################
@export_group("Movement Stats")
@export var weight:float = 1.0 #How the character is affected by knockback.
#1.5 = light, 1.0 = medium, 0.5 = heavy, that's the gist
@export var traction:int = 5 #the speed the character decelerates at on the ground
@export var friction:float = 0.9
@export var min_speed:int = 10
@export var walk_speed:int = 200
@export var ground_acceleration = 100
@export var dash_frames:int = 10 #the number of frames before a dash reverts to idle or becomes a run
@export var dash_speed:int = 600 #the speed the character moves at while dashing
@export var run_speed:int = 500

@export var gravity:int = 1400 #the acceleration due to gravity
@export var fall_speed:int = gravity #the maximum downward speed when falling
@export var fast_fall_speed:int = 800 #the speed the character falls when fastfalling


@export var jumpsquat_frames:int = 6 #the amount of frames which decides between a fullhop and shorthop
@export var fullhop_v:int = gravity*0.4 #the upward velocity applied when doing a full-jump
@export var shorthop_v:int = gravity*0.25 #the upward velocity applied when doing a half-jump
@export var aerial_jump_v:int = fullhop_v #the upward velocity of an aerial jump
@export var aerial_jump_count:int = 1

@export var air_acceleration:int = 200 #horizontal acceleration in the air
@export var max_airspeed:int = 300 #the maximum horizontal airspeed


## APPEARANCE
#@export_group("Appearance")
#@export var color_1:Color = Color(0, 0, 0, 0)
#@export var color_2:Color = Color(0, 0, 0, 0)
#endregion



######################
## MEMBER VARIABLES ##
######################
var frames:int = 0
var i_frames:int = 0
var aerial_jumps:int = 1
var hitstun_frames:int = 0
var facing_right:bool:
	set(new_facing):
		facing_right = new_facing
		anim.flip_h = not facing_right

# STATE THINGS
const initial_state:String = "StateIdle"
var prev_state:State
var prev_state_name:String
var current_state: State
var current_state_name:String
var states: Dictionary

# TECHNICAL THINGS
@export var controller_id:int = -1
var input:DeviceInput
var controller:Controller
var anim:AnimatedSprite2D

#func _init(pos:Vector2) -> void:
	#super._init()
	#position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#controller_id = PlayerManager.request_id()
	input = DeviceInput.new(controller_id)
	controller = Controller.new(input)
	
	anim = get_node("AnimatedSprite2D")
	# Add all the child states into the states dict
	for state in find_children("*", "State"):
		#state.parent = self
		states[state.name] = state
		state.input = input
		state.controller = controller
		state.anim = anim
	set_state(initial_state)

func register_state(new_state:State):
	states[new_state.name] = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_frames() -> void:
	frames = 0

func set_state(state_name:String):
	if states.has(state_name):
		reset_frames()
		#print(state_name)
		$StateLabel.text = state_name
		if prev_state != null:
			prev_state.exit_state(current_state)
			prev_state.disable()
		prev_state = current_state
		prev_state_name = current_state_name
		current_state = states[state_name]
		current_state_name = state_name
		current_state.enter_state(prev_state)
		current_state.enable()
	else:
		print("Invalid state_name: %s" % state_name)
#		Maybe make this crash in the future

func state_transition(delta:float):
	var next_state_name = current_state.get_transition(delta)
	if next_state_name != null:
		set_state(next_state_name)

# This is the function where character-specific transitions go.
# Things like attacks and special stuff
# This is to decouple generic states from character specific ones
func get_move_transition(delta:float):
	pass

# More consistent, meant for game logic.
func _physics_process(delta: float) -> void:
	frames += 1
	move_and_slide()
	#print("StateMachine is running _physics_process")
	var attack_state_name = get_move_transition(delta)
	if attack_state_name != null:
		set_state(attack_state_name)
	else:
		state_transition(delta)
	if current_state:
		current_state.state_logic(delta)

func enable_collision(layer_index:int):
	set_collision_mask_value(layer_index, true)

func disable_collision(layer_index:int):
	set_collision_mask_value(layer_index, false)

const PLATFORM_LAYER_INDEX = 3

func enable_platform_collision():
	enable_collision(PLATFORM_LAYER_INDEX)

func disable_platform_collision():
	disable_collision(PLATFORM_LAYER_INDEX)
