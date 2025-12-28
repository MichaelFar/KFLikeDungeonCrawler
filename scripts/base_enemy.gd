extends CharacterBody3D

class_name BaseEnemy


@export var routineStrategy : RoutinePatrolAIStrategy
@export var playerDetectedStrategy : PlayerDetectedAIStrategy

@export var patrollingAIData : PatrollingAIData



func _ready() -> void:
	
	patrollingAIData.populate_values(routineStrategy)
	patrollingAIData.populate_values(playerDetectedStrategy)
	
	routineStrategy.execute_strategy()
	
func _physics_process(delta: float) -> void:
	
	routineStrategy.strategy_process(delta)
	playerDetectedStrategy.strategy_process(delta)
	
