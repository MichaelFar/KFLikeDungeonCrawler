@tool

extends ConditionLeaf



func tick(actor: Node, blackboard: Blackboard) -> int:
	
	
	if(actor is not BaseEnemy):
		
		return FAILURE
	
	elif(actor is BaseEnemy):
		
		if(actor.playerInDetectionZone):

			return SUCCESS
	
	return FAILURE
