@tool

extends ActionLeaf

var shouldNotMove : bool = false

@export var choosePatrolPointAction : ChoosePatrolPointActionLeaf

func _ready() -> void:
	pass

func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemy_actor : BaseEnemy = actor
	
	if(shouldNotMove):
		enemy_actor.velocity = Vector3.ZERO
		return FAILURE
	
	if(enemy_actor.destinationPoint != Vector3.ZERO):
		
		enemy_actor.move_to_point(enemy_actor.destinationPoint, enemy_actor.globalDelta)
		
		return SUCCESS
			
	return FAILURE

func set_should_not_move():
	
	shouldNotMove = !shouldNotMove
