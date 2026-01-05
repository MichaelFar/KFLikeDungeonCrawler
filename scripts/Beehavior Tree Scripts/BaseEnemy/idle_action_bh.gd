@tool

extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	if(enemy_actor.animationPlayer.current_animation != enemy_actor.animationDict["idling"]):
		enemy_actor.animationPlayer.play(enemy_actor.animationDict["idling"])
	print("idling")
	return SUCCESS
