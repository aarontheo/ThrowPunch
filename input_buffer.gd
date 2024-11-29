# Original Input Buffer script by johnnyneverwalked (https://github.com/johnnyneverwalked)

extends Node
# Keeps track of recent inputs in order to make timing windows more flexible.
# Intended use: Add this file to your project as an Autoload script and have other objects call the class' methods.
# (more on AutoLoad: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

# How many milliseconds ahead of time the player can make an input and have it still be recognized.
# I chose the value 150 because it imitates the 9-frame buffer window in the Super Smash Bros. Ultimate game.
const BUFFER_WINDOW: int = 150
# The godot default deadzone is 0.2 so I chose to have it the same
const JOY_DEADZONE: float = 0.2

var keyboard_timestamps: Dictionary
var joypad_timestamps: Dictionary
var action_timestamps: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

	# Initialize all dictionary entries.
	keyboard_timestamps = {}
	joypad_timestamps = {}
	action_timestamps = {}

# TODO: Need to fix- InputBuffer DOES NOT track device_id of input events.

# Called whenever the player makes an input.
func _input(event: InputEvent) -> void:
	#print("Event: ", event.as_text())
	#print("Event Device: ", event.device)
	if event is InputEventKey:
		if !event.pressed or event.is_echo():
			return

		var scancode: int = event.keycode
#		eventkey contains the normal event info plus the device_id.
		var eventkey = [scancode, -1] # -1 for keyboard
		keyboard_timestamps[eventkey] = Time.get_ticks_msec()
	elif event is InputEventJoypadButton:
		if !event.pressed or event.is_echo():
			return

		var button_index: int = event.button_index
		var eventkey = [button_index, event.device]
		#print("Button index: ", button_index)
		joypad_timestamps[eventkey] = Time.get_ticks_msec()
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) < JOY_DEADZONE:
			return

		var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
		var eventkey = [axis_code, event.device]
		#print("Axis code: ", axis_code)
		joypad_timestamps[eventkey] = Time.get_ticks_msec()
	elif event is InputEventAction:
		#print(event)
		#print(event.pressed)
		if !event.pressed or event.is_echo():
			return

		var action_name = event.action
		var eventkey = [action_name, event.device]
		action_timestamps[eventkey] = Time.get_ticks_msec()

# Returns whether any of the keyboard keys or joypad buttons in the given action were pressed within the buffer window.
func is_action_press_buffered(action: String) -> bool:
	# Get the inputs associated with the action. If any one of them was pressed in the last BUFFER_WINDOW milliseconds,
	# the action is buffered.
	if action_timestamps.has(action):
		#print(action)
		var delta = Time.get_ticks_msec() - action_timestamps[action]
		if delta <= BUFFER_WINDOW:
			_invalidate_action(action)
			return true
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.keycode
			var eventkey = [scancode, -1] # -1 for keyboard
			if keyboard_timestamps.has(eventkey):
				if Time.get_ticks_msec() - keyboard_timestamps[eventkey] <= BUFFER_WINDOW:
					# Prevent this method from returning true repeatedly and registering duplicate actions.
					_invalidate_action(action)
					return true;
		elif event is InputEventJoypadButton:
			var button_index: int = event.button_index
			var eventkey = [button_index, event.device]
			if joypad_timestamps.has(eventkey):
				var delta = Time.get_ticks_msec() - joypad_timestamps[eventkey]
				if delta <= BUFFER_WINDOW:
					_invalidate_action(action)
					return true
		elif event is InputEventJoypadMotion:
			if abs(event.axis_value) < JOY_DEADZONE:
				return false
			var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
			var eventkey = [axis_code, event.device]
			if joypad_timestamps.has(eventkey):
				var delta = Time.get_ticks_msec() - joypad_timestamps[eventkey]
				if delta <= BUFFER_WINDOW:
					_invalidate_action(action)
					return true
		elif event is InputEventAction:
			var action_name = event.action
			var eventkey = [action_name, event.device]
			action_timestamps[eventkey] = Time.get_ticks_msec()
			if action_timestamps.has(eventkey):
				var delta = Time.get_ticks_msec() - action_timestamps[eventkey]
				if delta <= BUFFER_WINDOW:
					_invalidate_action(action)
					return true

	# If there's ever a third type of buffer-able action (mouse clicks maybe?), it'd probably be worth it to generalize
	# the repetitive keyboard/joypad code into something that works for any input method. Until then, by the YAGNI
	# principle, the repetitive stuff stays >:)

	return false


# Records unreasonable timestamps for all the inputs in an action. Called when IsActionPressBuffered returns true, as
# otherwise it would continue returning true every frame for the rest of the buffer window.
func _invalidate_action(action: String) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.keycode
			var eventkey = [scancode, -1] # -1 for keyboard
			if keyboard_timestamps.has(eventkey):
				keyboard_timestamps[eventkey] = 0
		elif event is InputEventJoypadButton:
			var button_index: int = event.button_index
			var eventkey = [button_index, event.device]
			if joypad_timestamps.has(eventkey):
				joypad_timestamps[eventkey] = 0
		elif event is InputEventJoypadMotion:
			var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
			var eventkey = [axis_code, event.device]
			if joypad_timestamps.has(eventkey):
				joypad_timestamps[eventkey] = 0
		elif event is InputEventAction:
			var action_name = event.action
			var eventkey = [action_name, event.device]
			if action_timestamps.has(eventkey):
				action_timestamps[eventkey] = 0
