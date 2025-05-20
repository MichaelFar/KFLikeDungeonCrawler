extends Node2D

var frameCounter : int = 0 #I know I know

@export var brushScene : PackedScene

@export var color : Color

@export var colorArray :=[]

var inDrawZone : bool = false

var isActive : bool = true

var startPoint : Vector2

var currentPoint : Vector2

var linesArray := []

var newLine := []

var debugSaveImage : Image

var lineWidth := 10

signal released_mouse

func _process(_delta):
	
	if(Input.is_action_pressed("draw")):
		
		var mouse_position = get_viewport().get_mouse_position()
		
		frameCounter += 1
		
		color = colorArray[frameCounter % 2]
		
		if mouse_position != currentPoint && inDrawZone:
			currentPoint = mouse_position
			newLine.append(currentPoint)
			queue_redraw()
			
			if(frameCounter % 2 == 0):
				
				startPoint = currentPoint
				newLine.append(startPoint)
			
	elif(Input.is_action_just_released("draw")):
		
		linesArray.append(newLine)
		
		newLine = []
		
func _input(event: InputEvent) -> void:
	
	if(event.is_action_released("save_image")):
		save_rune_data()
		
func _draw():
	
	#draw_line(startPoint, currentPoint, color, 10)
	for i in newLine.size():
			
			if(i + 1 != newLine.size()):
				
				draw_line(newLine[i], newLine[i + 1], color, lineWidth, true)
	
	for line in linesArray:
		
		for i in line.size():
			
			if(i + 1 != line.size()):
				
				draw_line(line[i], line[i + 1], color, lineWidth, true)

func save_rune_data():
	
	var img = get_viewport().get_texture().get_image()
	
	img.convert(Image.FORMAT_RGBA8)
	
	debugSaveImage = img
	
	debugSaveImage.save_png("user://testpng.png")
	
	
	var save_file = FileAccess.open("user://rune_save.save", FileAccess.WRITE)
	
	
	for i in range(linesArray.size()):
		var line_dict = {
		"line_array" + str(i) : JSON.from_native(linesArray[i])
		}
		var json_string = JSON.stringify(line_dict)
		save_file.store_line(json_string)

func load_rune_data():
	
	if not FileAccess.file_exists("user://rune_save.save"):
		return 
	
	var save_file = FileAccess.open("user://rune_save.save", FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		#linesArray = rune_data["line_array"]
		#print(json.data)
		for i in json.data.keys():
			if(i.contains("line_array")):
				
				linesArray.append(JSON.to_native(json.data[i]))
		
static func string_to_vector2(string := "") -> Vector2:
	
	if string:
		
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(float(array[0]), float(array[1]))

	return Vector2.ZERO		
	
func _on_area_2d_mouse_entered() -> void:
	
	inDrawZone = true
	
func _on_area_2d_mouse_exited() -> void:
	
	inDrawZone = false

func _on_button_button_up() -> void:
	
	linesArray = []
	
	queue_redraw()


func _on_button_2_button_up() -> void:
	load_rune_data()
	queue_redraw()
