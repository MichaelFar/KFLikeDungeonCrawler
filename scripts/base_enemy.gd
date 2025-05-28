extends Node3D

class_name BaseEnemy

@export var animationPlayer : AnimationPlayer

@export var navAgent : NavigationAgent3D

@export var animationDict = {
	"moving": "",
	"idling": "",
	"attacking" : ""
}

enum EnemyStates {WANDERING, IDLING, PURSUING, ATTACKING}

var enemyState : EnemyStates = EnemyStates.IDLING
#States will be based on timers and loops, I will try to avoid physics tick 

func _ready() -> void:
	
	idle_state()
	
func idle_state():
	
	animationPlayer.play(animationDict["idling"])
	pass
	
