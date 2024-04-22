extends Node2D

@export var MAP_TEXTURE : Texture2D
@export var POLYGON_PRECISION : float = 2.0

var COLOR_TO_REGION: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var county_info = make_dictionary_county_information()
	var current_color: Color
	
	make_regions_from_img()
	for id in county_info:
		current_color = Color(county_info[id]["color"])
		if COLOR_TO_REGION.has(current_color):
			COLOR_TO_REGION[current_color].is_clicked.connect(update_hud)
			COLOR_TO_REGION[current_color].visible = true
			COLOR_TO_REGION[current_color].name = county_info[id]["name"]
			COLOR_TO_REGION[current_color].INFO_CITY = Population.new(county_info[id]["pop_town"], true)
			COLOR_TO_REGION[current_color].INFO_COUNTRYSIDE = Population.new(county_info[id]["pop_cside"], false)

func make_dictionary_county_information():
	var file = FileAccess.open("res://Data/locations.csv", FileAccess.READ)
	var info: Array[PackedStringArray] = []
	var dictionary_county: Dictionary = {}
	var header = file.get_csv_line()
	var result = file.get_csv_line()
	var id: int = -1
	
	while Array(result) != [""]:
		info.append(result)
		id = int(result[0])
		dictionary_county[id] = {}
		for i in range(1, len(result)):
			if result[i].is_valid_float():
				dictionary_county[id].merge({header[i]: float(result[i])})
			elif result[i].is_valid_int():
				dictionary_county[id].merge({header[i]: int(result[i])})
			else:
				dictionary_county[id].merge({header[i]: result[i]})
		result = file.get_csv_line()
	return dictionary_county

func make_regions_from_img():
	var image: Image = MAP_TEXTURE.get_image()
	var pixel_color: Dictionary = pixel_color_to_dict(image)
	var region_bitmap = BitMap.new()
	var area: County

	region_bitmap.create_from_image_alpha(image)
	for color in pixel_color:
		if color in [Color.BLACK]:
			continue
		area = County.new()
		area.POLYGON = make_region_to_polygon(color, pixel_color[color], image.get_size())
		area.name = color.to_html(false)
		area.COLOR = color
		area.visible = false
		COLOR_TO_REGION[color] = area
		get_node("Regions").add_child(area)
	print("Region is Done.")

# Transforms bitmap image into polygon
func make_region_to_polygon(color: Color, positions: Array, shape: Vector2i):
	var region_bitmap = BitMap.new()
	var region_img = Image.create(shape.x, shape.y, false, Image.FORMAT_RGBA8)
	var region_shape = Polygon2D.new()
	var polygon_coor : Array[PackedVector2Array] = []
	
	for pos in positions:
		region_img.set_pixelv(pos, color)
	region_bitmap.create_from_image_alpha(region_img)
	polygon_coor = region_bitmap.opaque_to_polygons(Rect2(Vector2(), shape), POLYGON_PRECISION)
	region_shape.set_polygon(polygon_coor[0])
	region_shape.modulate = color
	print(color, " polygon is Done.")
	return region_shape.get_polygon()

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
	print("Color Dictionary is Done.")
	return colors_pos

func update_hud(county: County):
	$Hud.visible = true
	$Hud/Panel/Name.text = county.name
	$Hud/Panel/CityValues.INFO = county.INFO_CITY
	$Hud/Panel/CountrysideValues.INFO = county.INFO_COUNTRYSIDE
