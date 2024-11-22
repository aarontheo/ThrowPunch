# In the future, make this into a thing that can get inputs specific to a controller ID
# Might need to make this extend InputMap, so we can get that sweet sweet Godot input mapping integration?

extends Node
class_name Controller

var prev_x_axis:float = 0
var prev_y_axis:float = 0
var x_axis_velocity:float
var y_axis_velocity:float

# the proportion of the full movement of the stick to trigger a flick
# If set to 0.2, the stick must travel a fifth of it's axis within the frame window
# to trigger a flick.
#const flick_intensity_threshold = 0.5

const flick_speed = 0.45 #The stick must move by this amount or more in 1 frame to trigger a flick
const flick_deadzone = 0.5
const flick_repeat_frame_delay = 5 #The number of frames after a flick that another flick can be inputted

# When an axis is flicked, these will be either +1 or -1. When there is no flick, they are 0.
var flicked_h: bool = false
var flicked_v: bool = false
var x_frames:int = 0
var y_frames:int = 0
#TODO: Try making your own 'flick buffer' type thing, have flicks be a boolean that expires or is 'consumed'

#TODO: Can you edit the methods of MultiplayerInput or DeviceInput to use InputBuffer instead of Input?
# Or, add methods for buffered inputs to the thing.
# But first, you need to make sure that InputEvents specific to controllers get recorded by the inputbuffer

var frames:int = 0
var parent:Character
var input:DeviceInput

func _init(input:DeviceInput):
	self.input = input

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()

func x_axis() -> float:
	return input.get_axis("Left", "Right")

func y_axis() -> float:
	return input.get_axis("Up", "Down")

func _process(delta: float) -> void:
	pass

func flick_h():
	var flick_event = InputEventAction.new()
	flick_event.action = "Flick_h"
	flick_event.pressed = true
	input.parse_input_event(flick_event)

func flick_v():
	var flick_event = InputEventAction.new()
	flick_event.action = "Flick_v"
	flick_event.pressed = true
	input.parse_input_event(flick_event)

 # Called every frame. 'delta' is the elapsed time since the previous frame
func _physics_process(delta: float) -> void:
	frames += 1
	if flicked_h:
		if x_frames >= flick_repeat_frame_delay:
			flicked_h = false
		x_frames += 1
	if flicked_v:
		if y_frames >= flick_repeat_frame_delay:
			flicked_v = false
		y_frames += 1
	#print(x_frames)

	#print(InputBuffer.is_action_press_buffered("Flick_h"))

	x_axis_velocity = x_axis() - prev_x_axis
	prev_x_axis = x_axis()
	y_axis_velocity = y_axis() - prev_y_axis
	prev_y_axis = y_axis()

	#if not x_axis() and flicked_h:
		#flicked_h = false
	#if not y_axis() and flicked_v:
		#flicked_v = false

#	To register stick flicks, the velocity needs to be AWAY from 0.
	if !flicked_h:
		if x_axis() < 0 and x_axis_velocity <= -flick_speed:
			flicked_h = true
			flick_h()
		elif x_axis() > 0 and x_axis_velocity >= flick_speed:
			flicked_h = true
			flick_h()

	if !flicked_v:
		if y_axis() < 0 and y_axis_velocity <= -flick_speed:
			flicked_v = true
			flick_v()
		elif y_axis() > 0 and y_axis_velocity >= flick_speed:
			flicked_v = true
			flick_v()

	#if abs(x_axis()) >= flick_deadzone:
		#if abs(x_axis_velocity) >= flick_speed:
			#flick_h()
	#if abs(y_axis()) >= flick_deadzone:
		#if abs(y_axis_velocity) >= flick_speed:
			#flick_v()
