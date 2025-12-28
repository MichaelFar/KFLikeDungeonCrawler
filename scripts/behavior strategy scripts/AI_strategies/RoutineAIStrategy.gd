extends AIStrategy

class_name RoutinePatrolAIStrategy

var animationPlayer : AnimationPlayer

var navAgent : NavigationAgent3D

var IdleTimer : Timer

var WanderTimer : Timer

var wanderRegion : WanderRegion

var ownerAI : CharacterBody3D

@export var speed : float

@export var animationDict = {
	"moving": "",
	"idling": "",
	"attacking" : ""
}

var destinationPoint : Vector3

enum EnemyStates {WANDERING, IDLING, PURSUING, ATTACKING}

@export var startingState : EnemyStates

@export var distanceToWanderTargetAcceptance : float = 0.3

var enemyState : EnemyStates : #Handles initial settings for switching states and sets processing
	
		set(value):
			
			enemyState = value
			
			match value:
				
				EnemyStates.WANDERING:
					
					animationPlayer.play(animationDict["moving"])
					#set_process(true)
					WanderTimer.start()
					#choose_point()
					for i in navAgent.navigation_finished.get_connections():
						
						navAgent.navigation_finished.disconnect(i["callable"])
					
					#navAgent.navigation_finished.connect(change_state.bind(EnemyStates.IDLING))
					finished_wandering_to_point.connect(change_state.bind(EnemyStates.IDLING))
					print("In wander state")
					
					
				EnemyStates.IDLING:
					WanderTimer.stop()
					#await get_tree().physics_frame
					#set_process(false)
					#speed = 0
					ownerAI.velocity = Vector3.ZERO
					
					idle_state()
					print("In idle state")

		get:
			
			return enemyState

signal finished_wandering_to_point

func populate_values(new_AI_data : InstanceAIData):
	
	if(new_AI_data is InstancePatrollingAIData):
		animationPlayer = new_AI_data.animationPlayer
		navAgent = new_AI_data.navAgent
		IdleTimer = new_AI_data.IdleTimer
		WanderTimer = new_AI_data.WanderTimer
		wanderRegion = new_AI_data.wanderRegion
		ownerAI = new_AI_data.ownerAI
	
	
	IdleTimer.timeout.connect(change_state.bind(EnemyStates.WANDERING))
	WanderTimer.timeout.connect(change_state.bind(EnemyStates.IDLING))
#Potentially, the strategy would be released by this string
#Allows for, say, charge attacks, or blocking as with original functionality
func execute_strategy(): 
	
	#await ownerAI.get_tree().physics_frame
	#choose_point()
	enemyState = startingState
	#finished_wandering_to_point.connect(change_state)
	
func strategy_process(delta : float):
	match enemyState:
		
		EnemyStates.WANDERING:
					
			move_to_point(destinationPoint, delta)
					
		EnemyStates.IDLING:
			
			pass
			
		EnemyStates.PURSUING:
			
			pass
		
		EnemyStates.ATTACKING:
			pass
		
	ownerAI.move_and_slide()
	
func move_to_point(destination : Vector3, delta):
	print("Target is " + str(destination))
	navAgent.target_position = destination
	var direction = navAgent.get_next_path_position() - ownerAI.global_position
	direction = direction.normalized()
	if(direction != Vector3.ZERO):
		var target: Basis = Basis.looking_at(direction)
		
		ownerAI.basis = ownerAI.basis.slerp(target.orthonormalized(), delta).orthonormalized()
	
	ownerAI.velocity = direction * speed
	
	if(destination.distance_to(ownerAI.global_position) <= distanceToWanderTargetAcceptance):
		
		finished_wandering_to_point.emit()
		finished_wandering_to_point.disconnect(finished_wandering_to_point.get_connections()[0]["callable"])
		
func idle_state():
	
	#destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	choose_point()
	animationPlayer.play(animationDict["idling"])
	IdleTimer.start()

func choose_point():
	destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	

func change_state(new_state : EnemyStates):
	
	enemyState = new_state
