extends Character
class_name 

# This is the function where character-specific transitions go.
# Things like attacks and special stuff.
# This is to decouple generic states from character specific ones.
# To enter a specific state, return the name of the State node.
func get_move_transition(delta:float):
	pass
