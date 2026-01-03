@tool

extends ActionLeaf


var hasChosenPoint : bool = false


func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	if(!hasChosenPoint):
		print("Choosing new point")
		var shouldIdle = enemy_actor.choose_patrol_point()
		
		enemy_actor.animationPlayer.play(enemy_actor.animationDict["moving"])
		enemy_actor.increment_point_index()
		hasChosenPoint = true
	elif(enemy_actor.animationPlayer.current_animation != enemy_actor.animationDict["moving"]):
		hasChosenPoint = false
		
	#print("Choosing point")
	return FAILURE


func _on_navigation_agent_3d_target_reached() -> void:
	print("Reached target")
	hasChosenPoint = false
