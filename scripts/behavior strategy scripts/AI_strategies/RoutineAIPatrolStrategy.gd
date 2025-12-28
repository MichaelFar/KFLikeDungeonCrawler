extends AIStrategy

class_name RoutinePatrolAIStrategy

var animationPlayer : AnimationPlayer

var navAgent : NavigationAgent3D

var IdleTimer : Timer

var WanderTimer : Timer

var patrolPath : Path3D

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

var enemyState : EnemyStates : #Handles initial settings for switching states and sets processing
	
		set(value):
			
			enemyState = value
			
			match value:
				
				EnemyStates.WANDERING:
					
					animationPlayer.play(animationDict["moving"])
					#set_process(true)
					WanderTimer.start()
					choose_point()
					
					#navAgent.navigation_finished.connect(change_state.bind(EnemyStates.IDLING))
					#finished_wandering_to_point.connect(change_state.bind(EnemyStates.IDLING))
					print("In wander state")
					
					
				EnemyStates.IDLING:
					#WanderTimer.stop()
					#await get_tree().physics_frame
					#set_process(false)
					#speed = 0
					ownerAI.velocity = Vector3.ZERO
					
					idle_state()
					print("In idle state")

		get:
			
			return enemyState

var currentPathPointIndex : int = 0

@export var numPointsBeforeIdle : int = 0 #O means never idle just patrol, anything greater and that will be how many points before Idle

var allBakedPoints: PackedVector3Array

var directionOnPath = 1

var originalSpeed := 0.0

signal finished_wandering_to_point

func populate_values(new_AI_data : InstanceAIData):
	
	if(new_AI_data is InstancePatrollingAIData):
		animationPlayer = new_AI_data.animationPlayer
		navAgent = new_AI_data.navAgent
		IdleTimer = new_AI_data.IdleTimer
		WanderTimer = new_AI_data.WanderTimer
		patrolPath = new_AI_data.patrolPath
		ownerAI = new_AI_data.ownerAI
	
	
	IdleTimer.timeout.connect(change_state.bind(EnemyStates.WANDERING))
	navAgent.target_reached.connect(navigation_finished_behavior)
	originalSpeed = speed
	allBakedPoints = patrolPath.curve.get_baked_points()
	
#Potentially, the strategy would be released by this string
#Allows for, say, charge attacks, or blocking as with original functionality
func execute_strategy(): 
	
	enemyState = startingState
	
func strategy_process(delta : float):
	
	match enemyState:
		
		EnemyStates.WANDERING:
					
			move_to_point(destinationPoint, delta)
					
		EnemyStates.IDLING:
			
			ownerAI.velocity = Vector3.ZERO
			
		EnemyStates.PURSUING:
			
			pass
		
		EnemyStates.ATTACKING:
			pass
		
	ownerAI.move_and_slide()
	
func move_to_point(destination : Vector3, delta):
	#print("Target is " + str(destination))
	await ownerAI.get_tree().physics_frame
	navAgent.target_position = destination
	var direction = navAgent.get_next_path_position() - ownerAI.global_position
	direction = direction.normalized()
	
	if(direction != Vector3.ZERO):
		
		var target: Basis = Basis.looking_at(direction)
		
		ownerAI.basis = ownerAI.basis.slerp(target.orthonormalized(), delta).orthonormalized()
	
	ownerAI.velocity = direction * speed
		
func idle_state():
	
	#destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	choose_point()
	animationPlayer.play(animationDict["idling"])
	IdleTimer.start()

func choose_point():
	#destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	destinationPoint = allBakedPoints[currentPathPointIndex]
	print("Chosen index is " + str(currentPathPointIndex))
func increment_point_index():
	
	
	
	currentPathPointIndex += 1 * directionOnPath
	
	if(patrolPath.curve.closed):
		
		currentPathPointIndex = wrapi(currentPathPointIndex , 0, allBakedPoints.size())
	
	else:
		
		if(currentPathPointIndex == allBakedPoints.size() - 1):
			change_state(EnemyStates.IDLING)
			directionOnPath = -1
			print("reversing direction")
			
			
		if(currentPathPointIndex < 0):
			change_state(EnemyStates.IDLING)
			directionOnPath = 1
			
	if(numPointsBeforeIdle != 0):
		
		if(currentPathPointIndex % numPointsBeforeIdle == 0):
			
			change_state(EnemyStates.IDLING)
			
	else:
		
		choose_point()

func change_state(new_state : EnemyStates):
	
	enemyState = new_state
	
func navigation_finished_behavior():
	print("Reached end")
	increment_point_index()
	
func get_original_speed():
	return originalSpeed
