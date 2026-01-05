@tool

extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	
	if(enemy_actor.animationPlayer.current_animation == enemy_actor.animationDict["idling"]):
		return FAILURE
	return SUCCESS
