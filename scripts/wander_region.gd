@tool

extends Node3D

class_name WanderRegion

@export var meshBoundary : MeshInstance3D

@export var mesh : Mesh :
	set(value):
		
		mesh = value
		if(meshBoundary != null):
			
			meshBoundary.mesh = mesh
			meshCornerPoints = meshBoundary.global_transform * remove_duplicate_points_on_polygon()
	get:
		return mesh

var meshCornerPoints : PackedVector3Array

func _ready() -> void:
	#print(meshBoundary.global_transform * remove_duplicate_points_on_polygon())
	meshCornerPoints = meshBoundary.global_transform * remove_duplicate_points_on_polygon()

func remove_duplicate_points_on_polygon() -> PackedVector3Array:
	
	var final_point_vector : PackedVector3Array
	
	for i in meshBoundary.mesh.get_faces():
		
		if(i not in final_point_vector):
			
			final_point_vector.append(i)
		
	return final_point_vector

func generate_point_in_region(points : PackedVector3Array) -> Vector3:
	
	var randobj = RandomNumberGenerator.new()
	
	var min_x : float
	var min_z : float
	var max_x : float
	var max_z : float
	
	points.sort()
	
	min_x = points[0].x
	min_z = points[0].z
	max_x = points[points.size() - 1].x
	max_z = points[points.size() - 1].z
	#print(points)
	return Vector3(randobj.randf_range(min_x,max_x), 0, randobj.randf_range(min_z,max_z))
	
