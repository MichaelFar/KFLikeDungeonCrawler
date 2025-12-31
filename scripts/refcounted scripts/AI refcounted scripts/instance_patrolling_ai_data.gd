extends InstanceAIData

class_name InstancePatrollingAIData

var animationPlayer : AnimationPlayer

var navAgent : NavigationAgent3D

var IdleTimer : Timer

var WanderTimer : Timer

var patrolPath : Path3D

var ownerAI : CharacterBody3D

var detectionZone : Area3D

func _init(animation_player, nav_agent, idle_timer, wander_timer, patrol_path, owner_ai, detection_zone) -> void:
	animationPlayer = animation_player
	navAgent = nav_agent
	IdleTimer = idle_timer
	WanderTimer = wander_timer
	patrolPath = patrol_path
	ownerAI = owner_ai
	detectionZone = detection_zone
