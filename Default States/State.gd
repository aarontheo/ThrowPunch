extends Node2D
class_name State

var state_attributes = {}
var parent: CharacterBody2D
var controller:Controller
var input:DeviceInput
var anim: AnimatedSprite2D

#var frames:int = 0
var state_animation:String
var actionable:bool = true
var interruptible = true
#var sprite:AnimatedSprite2D #Could potentially use this

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	#print(parent)
#	Add the collision shapes that are children of this node
	#for collider in find_children("*", "CollisionShape2D"):
		#parent.shape_owner
	disable() #States are by default disabled.

func disable():
	hide()
	set_process(false)
	set_physics_process(false)

func enable():
	set_physics_process(true)
	set_process(true)
	show()

func add_attribute(attr:String):
	if not state_attributes.has(attr):
		state_attributes[attr] = state_attributes.size()

func has_attribute(attr:String):
	return state_attributes.has(attr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void: #test annotation
	#state_logic(delta)
	#frames += 1
	#var next_state = get_transition(delta)
	#if next_state != null:
		#parent.set_state(next_state)

func state_logic(delta:float) -> void:
	#frames += 1
	pass

func get_transition(delta:float):
	pass

func enter_state(old_state:State):
	pass

func exit_state(new_state:State):
	pass
