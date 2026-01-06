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

signal player_left_detection_zone

func _ready() -> void:
	
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
	
	await get_tree().physics_frame
	navAgent.target_position = destination
	var direction = navAgent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	if(direction != Vector3.ZERO):
		
		var target: Basis = Basis.looking_at(direction)
		
		basis = basis.slerp(target.orthonormalized(), delta).orthonormalized()
	
	velocity = direction * speed
		
func choose_patrol_point():
	
	if(allBakedPoints.size() != 0):
		
		destinationPoint = allBakedPoints[currentPathPointIndex]
	
func increment_point_index():
	
	currentPathPointIndex += 1 * directionOnPath
	currentPathPointIndex = clamp(currentPathPointIndex, 0, allBakedPoints.size() - 1)
	if(patrolPath.curve.closed):
		
		currentPathPointIndex = wrapi(currentPathPointIndex , 0, allBakedPoints.size() - 1)
		
	else:
		
		if(currentPathPointIndex == allBakedPoints.size() - 1):
			
			directionOnPath = -1
			
		if(currentPathPointIndex <= 0):
			
			directionOnPath = 1
		

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
		player_left_detection_zone.emit()
		print("Player exited detection zone")
		
