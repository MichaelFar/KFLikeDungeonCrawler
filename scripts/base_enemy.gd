extends CharacterBody3D

class_name BaseEnemy

#@export var animationPlayer : AnimationPlayer
#
#@export var navAgent : NavigationAgent3D
#
#@export var IdleTimer : Timer
#
#@export var WanderTimer : Timer
#
#@export var wanderRegion : WanderRegion
#
#@export var speed : float
#
#@export var animationDict = {
	#"moving": "",
	#"idling": "",
	#"attacking" : ""
#}

@export var routineStrategy : RoutinePatrolAIStrategy
@export var playerDetectedStrategy : PlayerDetectedAIStrategy

@export var patrollingAIData : PatrollingAIData

#enum EnemyStates {WANDERING, IDLING, PURSUING, ATTACKING}
#
#@onready var enemyState : EnemyStates = EnemyStates.IDLING : #Handles initial settings for switching states and sets processing
	#
		#set(value):
			#
			#enemyState = value
			#
			#match value:
				#
				#EnemyStates.WANDERING:
					#
					#animationPlayer.play(animationDict["moving"])
					#set_process(true)
					#WanderTimer.start()
					#
					#for i in navAgent.navigation_finished.get_connections():
						#
						#navAgent.navigation_finished.disconnect(i["callable"])
					#
					#navAgent.navigation_finished.connect(change_state.bind(EnemyStates.IDLING))
					#
					#print("In wander state")
					#
					#
				#EnemyStates.IDLING:
					#WanderTimer.stop()
					#await get_tree().physics_frame
					#set_process(false)
					##speed = 0
					#velocity = Vector3.ZERO
					#
					#idle_state()
					#print("In idle state")
					#
				#EnemyStates.PURSUING:
					#pass
				#
				#EnemyStates.ATTACKING:
					#pass
					#
		#get:
			#
			#return enemyState
	#
#var destinationPoint : Vector3
#
#

func _ready() -> void:
	
	patrollingAIData.populate_values(routineStrategy)
	patrollingAIData.populate_values(playerDetectedStrategy)
	
	routineStrategy.execute_strategy()
	#IdleTimer.timeout.connect(change_state.bind(EnemyStates.WANDERING))
	#WanderTimer.timeout.connect(change_state.bind(EnemyStates.IDLING))
	
	#await get_tree().physics_frame
	#
	#enemyState = EnemyStates.IDLING
	
func _physics_process(delta: float) -> void:
	
	routineStrategy.strategy_process(delta)
	playerDetectedStrategy.strategy_process(delta)
	#match enemyState:
		#
		#EnemyStates.WANDERING:
					#
			#move_to_point(destinationPoint, delta)
					#
		#EnemyStates.IDLING:
			#
			#pass
			#
		#EnemyStates.PURSUING:
			#
			#pass
		#
		#EnemyStates.ATTACKING:
			#pass
		#
	#move_and_slide()
	
#func change_state(new_state : EnemyStates):
	#
	#enemyState = new_state
#
#func idle_state():
	#
	#destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	#
	#animationPlayer.play(animationDict["idling"])
	#IdleTimer.start()
	#
	#
#func move_to_point(destination : Vector3, delta):
	#
	#navAgent.target_position = destination
	#var direction = navAgent.get_next_path_position() - global_position
	#direction = direction.normalized()
	#var target: Basis = Basis.looking_at(direction)
	#
	#basis = basis.slerp(target.orthonormalized(), delta).orthonormalized()
	#velocity = direction * speed
	#
