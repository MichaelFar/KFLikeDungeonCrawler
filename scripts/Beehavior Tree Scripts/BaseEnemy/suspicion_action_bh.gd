@tool

extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var enemy_actor : BaseEnemy = actor
	enemy_actor.velocity = Vector3.ZERO
	print("checking")
	enemy_actor.animationPlayer.play(enemy_actor.animationDict["idling"])
	suspect_player(enemy_actor, enemy_actor.player, enemy_actor.globalDelta * 6)
	
	return SUCCESS

func suspect_player(actor: Node, target : Node3D, delta : float):
	
	
	var direction = target.global_position - actor.global_position
	direction = direction.normalized()
	if(direction != Vector3.ZERO):
		var destination_basis: Basis = Basis.looking_at(direction)
		print("Direction to look at is " + str(direction))
		actor.basis = actor.basis.slerp(destination_basis.orthonormalized(), delta).orthonormalized()
	
