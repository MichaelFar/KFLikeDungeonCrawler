extends CharacterBody3D

class_name BaseEnemy

#extends AIStrategy

#class_name RoutinePatrolAIStrategy

@export var animationPlayer : AnimationPlayer

@export var navAgent : NavigationAgent3D

@export var IdleTimer : Timer

@export var WanderTimer : Timer

@export var patrolPath : Path3D

#@export var ownerAI : CharacterBody3D

@export var detectionZone : Area3D

@export var speed : float


@export var threshHoldToDetect : float = 0.80

@export var animationDict = {
	"moving": "",
	"idling": "",
	"attacking" : ""
}

var destinationPoint : Vector3



enum EnemyStates {WANDERING, IDLING, SUSPICIOUS, PURSUING, ATTACKING}

@export var startingState : EnemyStates

var enemyState : EnemyStates : #Handles initial settings for switching states and sets processing
	
		set(value):
			
			enemyState = value
			
			match value:
				
				EnemyStates.WANDERING:
					pass
					#animationPlayer.play(animationDict["moving"])
					##set_process(true)
					#WanderTimer.start()
					#choose_patrol_point()
					#
					##navAgent.navigation_finished.connect(change_state.bind(EnemyStates.IDLING))
					##finished_wandering_to_point.connect(change_state.bind(EnemyStates.IDLING))
					#print("In wander state")
					
					
				EnemyStates.IDLING:
					#WanderTimer.stop()
					#await get_tree().physics_frame
					#set_process(false)
					#speed = 0
					pass
					#velocity = Vector3.ZERO
					#
					#idle_state()
					#print("In idle state")
				EnemyStates.SUSPICIOUS:
					pass
					#suspicion_state(suspicionTarget, globalDelta)

		get:
			
			return enemyState

var currentPathPointIndex : int = 0

@export var numPointsBeforeIdle : int = 0 #O means never idle just patrol, anything greater and that will be how many points before Idle

var allBakedPoints: PackedVector3Array

var directionOnPath = 1

var originalSpeed := 0.0

var player : Player

var playerInDetectionZone : bool = false

var suspicionTarget : Node3D

var globalDelta : float

signal finished_wandering_to_point

func _ready() -> void:
	IdleTimer.timeout.connect(change_state.bind(EnemyStates.WANDERING))
	navAgent.target_reached.connect(navigation_finished_behavior)
	originalSpeed = speed
	
	detectionZone.body_entered.connect(player_in_detection_zone)
	detectionZone.body_exited.connect(player_exited_detection_zone)
	if(patrolPath != null):
		allBakedPoints = patrolPath.curve.get_baked_points()
	var temp_points = allBakedPoints
	for i in temp_points.size():
		allBakedPoints[i] = temp_points[i] + patrolPath.get_parent().global_position

func _physics_process(delta: float) -> void:
	
	globalDelta = delta
	
	
	move_and_slide()
	
func move_to_point(destination : Vector3, delta):
	#print("Target is " + str(destination))
	await get_tree().physics_frame
	navAgent.target_position = destination
	var direction = navAgent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	if(direction != Vector3.ZERO):
		
		var target: Basis = Basis.looking_at(direction)
		
		basis = basis.slerp(target.orthonormalized(), delta).orthonormalized()
	
	velocity = direction * speed
		
func idle_state():
	
	#destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	
	animationPlayer.play(animationDict["idling"])
	if(patrolPath != null):
		choose_patrol_point()
		IdleTimer.start()
	

func choose_patrol_point():
	#destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	if(allBakedPoints.size() != 0):
		destinationPoint = allBakedPoints[currentPathPointIndex]
	#print("Chosen index is " + str(currentPathPointIndex))
func increment_point_index() -> bool:
	
	currentPathPointIndex += 1 * directionOnPath
	
	if(patrolPath.curve.closed):
		
		currentPathPointIndex = wrapi(currentPathPointIndex , 0, allBakedPoints.size())
		return false
	else:
		
		if(currentPathPointIndex == allBakedPoints.size() - 1):
			
			directionOnPath = -1
			#print("reversing direction")
			return true
			
		if(currentPathPointIndex < 0):
			
			directionOnPath = 1
			return true
			
	#choose_patrol_point()
	return false
func change_state(new_state : EnemyStates):
	
	enemyState = new_state
	
func navigation_finished_behavior():
	#print("Reached end")
	#increment_point_index()
	pass
func get_original_speed():
	return originalSpeed

func player_in_detection_zone(body: Node3D):
	
	if body is Player:
		
		player = body
		playerInDetectionZone = true
		print("Player entered detection zone")
		#check_stealth_level()
		
func player_exited_detection_zone(body : Node3D):
	
	if body is Player:
		
		playerInDetectionZone = false
		print("Player exited detection zone")
		
#func check_stealth_level() -> float:
	#
	#pass
		#
	##var detected_level = player.check_stealth(self, closeDetectionBeginDistance)
	##
	###if(detected_level >= .45):
		###
		###suspicionTarget = player
		###change_state(EnemyStates.SUSPICIOUS)
		##
	###print("Detection level of player is " + str(detected_level))
	##return detected_level

#func suspicion_state(target : Node3D, delta : float):
	#
	#
	#var direction = target.global_position - global_position
	#direction = direction.normalized()
	#if(direction != Vector3.ZERO):
		#var destination_basis: Basis = Basis.looking_at(direction)
		#print("Direction to look at is " + str(direction))
		#basis = basis.slerp(destination_basis.orthonormalized(), delta).orthonormalized()
	#
