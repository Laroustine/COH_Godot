extends Node2D

@export var MAP_TEXTURE : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	make_regions_from_img()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func make_regions_from_img():
	var image: Image = MAP_TEXTURE.get_image()
	var pixel_color: Dictionary = pixel_color_to_dict(image)
	var region_bitmap = BitMap.new()

	region_bitmap.create_from_image_alpha(image)
#	for polygon in region_bitmap.opaque_to_polygons(Rect2(Vector2(), region_bitmap.get_size()), 0.1):
#		var area = Polygon2D.new()
#		area.set_polygon(polygon)
#		get_node("Regions").add_child(area)
	for color in pixel_color:
		if color in [Color.BLACK]:
			continue
		var area = Polygon2D.new()
		area.name = color.to_html(false)
		area.set_polygon(make_region_to_polygon(color, pixel_color[area], region_bitmap.get_size()))
		get_node("Regions").add_child(area)

# Transforms bitmap image into polygon
func make_region_to_polygon(color: Color, positions: Array[Vector2i], shape: Vector2i):
	var region_bitmap = BitMap.new()
	var region_img = Image.create(shape.x, shape.y, false, Image.FORMAT_RGBA8)
	var region_shape = Polygon2D.new()
	
	for pos in positions:
		region_img.set_pixelv(pos, color)
	region_bitmap.create_from_image_alpha(region_img)
	region_shape.set_polygon(region_bitmap.opaque_to_polygons(Rect2(Vector2(), shape), 0.01)[0])
	region_shape.modulate = color
	return region_shape
#	var test = Sprite2D.new()
#	test.texture = region_img
#	return test

# Makes from an image a dictionary with colors for keys and a list of Vector2i as coordonates for pixels
func pixel_color_to_dict(img: Image) -> Dictionary:
	var colors_pos: Dictionary = {}
	var current_color: Color
	for x in img.get_width():
		for y in img.get_height():
			current_color = img.get_pixel(x, y).to_html(false)
			if not (current_color in colors_pos):
				colors_pos[current_color] = []
			colors_pos[current_color].append(Vector2i(x, y))
	return colors_pos
