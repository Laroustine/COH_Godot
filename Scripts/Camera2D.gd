extends Camera2D

@export var SPEED: float = 600.0
@export var SPEED_ZOOM: float = 0.8
@export var MIN_ZOOM: float = 0.1
@export var MAX_ZOOM: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var to_zoom = clamp(self.zoom.x + Input.get_axis("zoom_in", "zoom_out") * SPEED_ZOOM * delta, MIN_ZOOM, MAX_ZOOM)
	self.set_zoom(Vector2(to_zoom, to_zoom))
	self.position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED * delta * clamp(to_zoom, 0.8, 1.2)
