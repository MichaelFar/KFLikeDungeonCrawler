extends Node3D

#this script manages AI patrol paths

var pathChildren : Array[Path3D] = []

func _ready() -> void:
	
	populate_path_children()
	
func populate_path_children():
	
	for i in get_children():
		if( i is Path3D):
			pathChildren.append(i)
