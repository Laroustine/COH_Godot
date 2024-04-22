extends Area2D
class_name County

var COLLISION: CollisionPolygon2D = CollisionPolygon2D.new()
var POLYGON2D: Polygon2D = Polygon2D.new()
var COLOR_NORMAL: Color
var COLOR_SELECTED: Color
var IS_IN_AREA: bool = false
var INFO_CITY: Population = null
var INFO_COUNTRYSIDE: Population = null

signal is_clicked(county: County)

@export var POLYGON: PackedVector2Array:
	set(value):
		COLLISION.set_polygon(value)
		POLYGON2D.set_polygon(value)
		POLYGON = value

@export var COLOR: Color:
	set(value):
		COLOR = value
		COLOR_NORMAL = value
		COLOR_NORMAL.a = 0.2
		COLOR_SELECTED = value
		COLOR_SELECTED.a = 0.4
		POLYGON2D.set_color(COLOR_NORMAL)

func _init():
	super._init()
	add_child(COLLISION)
	add_child(POLYGON2D)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
func _process(_delta):
	if IS_IN_AREA:
		if INFO_CITY and INFO_COUNTRYSIDE and Input.is_action_just_pressed("ui_accept"):
			is_clicked.emit(self)

func _on_mouse_entered():
	POLYGON2D.set_color(COLOR_SELECTED)
	IS_IN_AREA = true

func _on_mouse_exited():
	POLYGON2D.set_color(COLOR_NORMAL)
	IS_IN_AREA = false
