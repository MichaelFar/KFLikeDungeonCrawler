@tool

extends Node3D

class_name ChessBoardManager

@export var boardDimensions : Vector2i = Vector2i(7,7)

@export var boardSpaceScene : PackedScene

@export var startingGlobalPosition : Vector3

@export var boardSpaceColorsArray: Array[Color]

var spaceSize : Vector2

func _ready() -> void:
	create_board_spaces()

func create_board_spaces():
	
	var color_array_index = 0
	
	for i in range(boardDimensions.x):
		
		print("new row")
		
		for j in range(boardDimensions.y):
			
			print("new space")
			
			if(get_children().size() == 0):
				
				var first_space = create_space(startingGlobalPosition, boardSpaceColorsArray[color_array_index])
				
				spaceSize = first_space.mesh.size
				
			else:
				
				print(color_array_index % boardSpaceColorsArray.size())
				
				var next_space = create_space(Vector3(i * spaceSize.x,0,j * spaceSize.y), boardSpaceColorsArray[color_array_index % boardSpaceColorsArray.size()])
				
			color_array_index += 1
			
		color_array_index += 1
		
func create_space(instance_position : Vector3, new_color : Color) -> ChessBoardSpace:
	
	var space_obj : ChessBoardSpace = boardSpaceScene.instantiate()
	
	add_child(space_obj)
	
	space_obj.global_position = instance_position
	
	space_obj.set_color(new_color)
	
	return space_obj
	
