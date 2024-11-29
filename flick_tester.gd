extends Node2D

const LOCATION:Vector2 = Vector2(0, 0)
const RADIUS: float = 40
var analog:Vector2 = Vector2.ZERO
var color:Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color = Color.CADET_BLUE

func _draw() -> void:
#	Draw the socket
	draw_circle(LOCATION, RADIUS, Color.DARK_GRAY)
#	Draw the stick
	draw_circle(LOCATION + analog*15, 30, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if InputBuffer.is_action_press_buffered("Flick_h"):
		color = Color.FIREBRICK
	else:
		color = Color.CADET_BLUE
	#analog.x = Controller.x_axis()
	#analog.y = Controller.y_axis()
	queue_redraw()
