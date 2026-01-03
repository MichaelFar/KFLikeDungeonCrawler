@tool

extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemy_actor : BaseEnemy = actor
	
	if(enemy_actor.destinationPoint != Vector3.ZERO):
		enemy_actor.move_to_point(enemy_actor.destinationPoint, enemy_actor.globalDelta)
		#print("Running patrol")
		#enemy_actor.move_and_slide()
		return SUCCESS
			
	return FAILURE
