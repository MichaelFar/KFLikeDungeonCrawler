extends InstanceAIData

class_name InstancePatrollingAIData

var animationPlayer : AnimationPlayer

var navAgent : NavigationAgent3D

var IdleTimer : Timer

var WanderTimer : Timer

var wanderRegion : WanderRegion

var ownerAI : CharacterBody3D

func _init(animation_player, nav_agent, idle_timer, wander_timer, wander_region, owner_ai) -> void:
	animationPlayer = animation_player
	navAgent = nav_agent
	IdleTimer = idle_timer
	WanderTimer = wander_timer
	wanderRegion = wander_region
	ownerAI = owner_ai
