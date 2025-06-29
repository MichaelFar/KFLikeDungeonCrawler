@tool

extends MeshInstance3D

class_name ChessBoardSpace

var isOccupied : bool = false

func set_color(new_color : Color):
	var spaceMaterial = StandardMaterial3D.new()
	spaceMaterial.albedo_color = new_color
	mesh.material = spaceMaterial
