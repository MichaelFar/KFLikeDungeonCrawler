extends CharacterBody3D

class_name BaseEnemy

@export var animationPlayer : AnimationPlayer

@export var navAgent : NavigationAgent3D

@export var IdleTimer : Timer

@export var WanderTimer : Timer

@export var wanderRegion : WanderRegion

@export var speed : float

@export var meshParent : Node3D

@export var animationDict = {
	"moving": "",
	"idling": "",
	"attacking" : ""
}

enum EnemyStates {WANDERING, IDLING, PURSUING, ATTACKING}

var enemyState : EnemyStates  : #Handles initial settings for switching states and sets processing
	
		set(value):
			
			enemyState = value
			
			match value:
				
				EnemyStates.WANDERING:
					
					animationPlayer.play(animationDict["moving"])
					set_process(true)
					WanderTimer.start()
					
					for i in navAgent.navigation_finished.get_connections():
						
						navAgent.navigation_finished.disconnect(i["callable"])
					
					navAgent.navigation_finished.connect(change_state.bind(EnemyStates.IDLING))
					
					print("In wander state")
					
					
				EnemyStates.IDLING:
					WanderTimer.stop()
					await get_tree().physics_frame
					set_process(false)
					#speed = 0
					velocity = Vector3.ZERO
					
					idle_state()
					print("In idle state")
					
				EnemyStates.PURSUING:
					pass
				
				EnemyStates.ATTACKING:
					pass
					
		get:
			
			return enemyState
	
var destinationPoint : Vector3


func _ready() -> void:
	
	
	IdleTimer.timeout.connect(change_state.bind(EnemyStates.WANDERING))
	WanderTimer.timeout.connect(change_state.bind(EnemyStates.IDLING))
	
	await get_tree().physics_frame
	
	enemyState = EnemyStates.IDLING
	
func _physics_process(delta: float) -> void:
	
	match enemyState:
		
		EnemyStates.WANDERING:
					
			move_to_point(destinationPoint, delta)
					
		EnemyStates.IDLING:
			
			pass
			
		EnemyStates.PURSUING:
			
			pass
		
		EnemyStates.ATTACKING:
			pass
		
	move_and_slide()
	
func change_state(new_state : EnemyStates):
	
	enemyState = new_state

func idle_state():
	
	destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	
	animationPlayer.play(animationDict["idling"])
	IdleTimer.start()
	
	
func move_to_point(destination : Vector3, delta):
	
	navAgent.target_position = destination
	var direction = navAgent.get_next_path_position() - global_position
	var target: Basis = Basis.looking_at(direction)
	direction = direction.normalized()
	
	basis = basis.slerp(target, delta)
	velocity = direction * speed
	print("moving")
func set_speed(new_speed : float):
	speed = new_speed
