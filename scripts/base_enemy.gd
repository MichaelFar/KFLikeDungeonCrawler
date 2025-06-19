extends CharacterBody3D

class_name BaseEnemy

@export var animationPlayer : AnimationPlayer

@export var navAgent : NavigationAgent3D

@export var IdleTimer : Timer

@export var wanderRegion : WanderRegion

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
					
					set_process(true)
					print("In wander state")
					pass
					
				EnemyStates.IDLING:
					
					set_process(false)
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
	
	enemyState = EnemyStates.IDLING
	
func _physics_process(delta: float) -> void:
	
	match enemyState:
		
		EnemyStates.WANDERING:
					
			pass
					
		EnemyStates.IDLING:
			
			pass
			
		EnemyStates.PURSUING:
			
			pass
		
		EnemyStates.ATTACKING:
			pass
		
	
func change_state(new_state : EnemyStates):
	
	enemyState = new_state

func idle_state():
	
	destinationPoint = wanderRegion.generate_point_in_region(wanderRegion.meshCornerPoints)
	
	animationPlayer.play(animationDict["idling"])
	IdleTimer.start()
	IdleTimer.timeout.connect(change_state.bind(EnemyStates.WANDERING))
	
func move_to_point(destination : Vector3):
	
	navAgent.target_position = destination
