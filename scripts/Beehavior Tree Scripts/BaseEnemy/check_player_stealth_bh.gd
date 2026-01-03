@tool

extends ConditionLeaf

@export var detectionThreshold : float = .45


@export var closeDetectionBeginDistance : float = 5.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	
	if(enemy_actor.player != null):
		var detected_level = enemy_actor.player.check_stealth(enemy_actor, closeDetectionBeginDistance)
		
		if(detected_level >= detectionThreshold):
			print("Player is suspicious")
			return SUCCESS
			
	return FAILURE
	
