extends Node

const JOY_DEADZONE: float = 0.2
const BUFFER_WINDOW: int = 150

var flick_buffer:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	flick_buffer = {}

#func update_flick_entry(event:InputEventJoypadMotion, device_id:int):
	# This function updates an entry in the flick buffer.
	# Each flick buffer entry has a device_id, an axis code, a timestamp, and a strength.



func _input(event:InputEvent):
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) < JOY_DEADZONE:
			return

		var axis_code:String = str(event.axis) + "_" + str(sign(event.axis_value))
		var eventkey = [axis_code, event.device]


func h_flick_buffered(device_id:int):
	pass

func v_flick_buffered(device_id:int):
	pass
