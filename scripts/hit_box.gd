extends Area3D
#this will have damage stuff in it
#For now, will apply a force to a rigid body on hit
@export var objectToFollow : Node3D

func _physics_process(delta: float) -> void:
	#global_position = objectToFollow.global_position
	rotation_degrees = objectToFollow.rotation_degrees
