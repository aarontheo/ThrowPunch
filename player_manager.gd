extends Node

# This class tracks the number of connected controllers, 
# and allows requesting of the next available controller ID.

# Player_id: controller_id | False (default false)
var player_dict:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_dict = {
		0:-1,
		1:-1,
	}

func _on_joy_connection_changed(device: int, connected: bool):
	pass

#Returns the next available id and sets it to 'in use'.
#If there are no available ids, returns -1.
#func request_id() -> int:
	#for key in player_dict.keys:
		#if player_dict[key] == -1:
			#player_dict[key] = 

func release_id(id:int):
	pass
