extends AIBaseData

class_name PatrollingAIData

@export var animationPlayer : AnimationPlayer

@export var navAgent : NavigationAgent3D

@export var IdleTimer : Timer

@export var WanderTimer : Timer

@export var patrolPath : Path3D

@export var ownerAI : CharacterBody3D

var strategyArray = []

func populate_values(strategy_to_populate : AIStrategy):
	var instance_patrolling_ai_data := InstancePatrollingAIData.new(animationPlayer, 
	navAgent,
	IdleTimer,
	WanderTimer,
	patrolPath,
	ownerAI)
	strategyArray.append(strategy_to_populate)
	strategy_to_populate.populate_values(instance_patrolling_ai_data)
	#if(melee_strategy.has_signal("tween_changed")):
		#melee_strategy.tween_changed.connect(strategy_tween_manager)

func set_speed(new_speed : float):
	for i in strategyArray:
		i.speed = new_speed
	#routineStrategy.speed = new_speed
